# Etapa V: Implementación de Temas Técnicos

En esta etapa incorporamos componentes avanzados del motor de base de datos (**Microsoft SQL Server**) sobre la base `proyectoBDD2026` (dominio de Comercio Minorista / Supermercado) para garantizar que la solución sea **robusta, consistente, segura, auditable y eficiente**.

A continuación se describe cada tema técnico implementado, por qué fue elegido, cómo se integra al sistema y cómo se demuestra su funcionamiento.

---

## 1. Procedimientos y Funciones Almacenadas

### A. Procedimiento Almacenado: `sp_RegistrarVentaCompleta`
* **¿Para qué se utiliza?**  
  Encapsula en una única operación lógica todo el circuito de registración de una venta en caja: inserta el encabezado en `Venta_Factura`, recupera el identificador generado (`SCOPE_IDENTITY()`), registra el renglón del producto vendido en `detalle_compra` y asienta el cobro en la tabla `pago`.
* **¿Por qué fue elegido y cómo se integra al sistema?**  
  Evita que la aplicación cliente o el cajero tengan que ejecutar múltiples sentencias `INSERT` manuales por separado. Además, centraliza la lógica de negocio en el servidor y permite otorgar permisos de ejecución (`EXECUTE`) al rol vendedor sin exponer permisos de escritura directa sobre las tablas sensibles.
* **Script de implementación:** [`sql/tecnico/etap5.sql`](../../sql/tecnico/etap5.sql)

### B. Función Almacenada Escalar: `dbo.fn_CalcularDescuentoCliente`
* **¿Para qué se utiliza?**  
  Recibe como parámetro el identificador de un cliente (`@Id_cliente`) y devuelve un porcentaje de descuento (`DECIMAL(5,2)`) calculado según el monto histórico acumulado de sus compras pagadas:
  * Mayor o igual a `$4000`: **10% de descuento (`0.10`)**
  * Mayor o igual a `$2000`: **5% de descuento (`0.05`)**
  * Menor a `$2000` o sin compras: **0% de descuento (`0.00`)**
* **¿Por qué fue elegida y cómo se integra al sistema?**  
  Permite reutilizar el cálculo de fidelización directamente dentro de cualquier consulta `SELECT` o reporte sin duplicar fórmulas ni subconsultas complejas.
* **Demostración de uso:**
  ```sql
  SELECT 
      Id_cliente, 
      Nombre,
      Apellido,
      dbo.fn_CalcularDescuentoCliente(Id_cliente) AS PorcentajeDescuento
  FROM Cliente;
  ```

---

## 2. Manejo de Transacciones

* **¿Para qué se utiliza?**  
  Dentro del procedimiento `sp_RegistrarVentaCompleta`, las tres inserciones (`Venta_Factura`, `detalle_compra` y `pago`) están envueltas en una transacción explícita (`BEGIN TRANSACTION` ... `COMMIT TRANSACTION`) controlada mediante un bloque `BEGIN TRY ... END TRY` y `BEGIN CATCH ... END CATCH`.
* **¿Por qué fue elegido y cómo se integra al sistema?**  
  Garantiza la propiedad de **Atomicidad (ACID)**: una venta nunca puede quedar registrada a medias (por ejemplo, una factura creada sin su detalle de productos o sin su registro de pago si ocurre un error de clave foránea o de tipo de datos). Si cualquiera de los tres pasos falla, el bloque `CATCH` ejecuta automáticamente `ROLLBACK TRANSACTION`, deshaciendo todos los cambios parciales y relanzando el error con `THROW`.
* **Demostración de funcionamiento (`sql/tecnico/Etap5_2.sql`):**
  ```sql
  EXEC sp_RegistrarVentaCompleta 
      @Id_cliente = 1, 
      @Id_Empleado = 1, 
      @Id_tipo_factura = 1, 
      @Id_metodo = 1, 
      @ImporteTotal = 4000, 
      @Id_producto = 1, 
      @Cantidad = 2;
  ```
  Al ejecutarse con datos válidos, el `COMMIT` confirma los registros en las 3 tablas simultáneamente. Si se invoca con un `@Id_metodo` inexistente, el `ROLLBACK` impide que quede una factura huérfana en `Venta_Factura`.

---

## 3. Triggers de Auditoría

* **¿Para qué se utiliza?**  
  Se creó la tabla `Auditoria_Precios` y el trigger `trg_AuditarCambioPrecioProducto` (`AFTER UPDATE` sobre la tabla `Producto`). Cada vez que se modifica la columna `Precio_venta` de un artículo (`IF UPDATE(Precio_venta)`), el trigger toma automáticamente los valores de las tablas virtuales `DELETED` (precio anterior) e `INSERTED` (precio nuevo) y guarda un registro histórico con el `Id_producto`, ambos precios, la fecha y hora exacta (`GETDATE()`) y el usuario que realizó el cambio (`SYSTEM_USER`).
* **¿Por qué fue elegido y cómo se integra al sistema?**  
  En un supermercado los precios cambian con frecuencia por inflación o promociones. Este mecanismo asegura trazabilidad total y automática desde el motor de base de datos, impidiendo que un cambio de precio pase desapercibido incluso si se realiza fuera del sistema de gestión.
* **Demostración de funcionamiento (`sql/tecnico/Etap5_2.sql`):**
  ```sql
  -- 1. Se actualiza el precio de venta del producto 1
  UPDATE Producto SET Precio_venta = 2500 WHERE Id_producto = 1;

  -- 2. Se verifica el registro generado automáticamente por el trigger
  SELECT * FROM Auditoria_Precios;
  ```

---

## 4. Seguridad (Control de Acceso y Roles DCL)

* **¿Para qué se utiliza?**  
  En el script [`sql/tecnico/Seguridad.sql`](../../sql/tecnico/Seguridad.sql) se implementa un esquema de seguridad basado en el **principio de menor privilegio** mediante dos roles de base de datos:
  1. **`Rol_Vendedor`**:
     * **Permisos otorgados (`GRANT`)**: Solo lectura (`SELECT`) sobre las tablas maestras necesarias para facturar (`Producto`, `Metodo_pago`, `Tipo_factura`, `Cliente`) y permiso de ejecución (`EXECUTE`) sobre el procedimiento `sp_RegistrarVentaCompleta`.
     * **Restricciones explícitas (`DENY`)**: Prohibición explícita de borrar o modificar ventas históricas (`DENY DELETE, UPDATE ON Venta_Factura`) y prohibición total de alterar la tabla de auditoría (`DENY INSERT, UPDATE, DELETE ON Auditoria_Precios`).
  2. **`Rol_Auditor`**:
     * **Permisos otorgados (`GRANT`)**: Permiso exclusivo de consulta (`SELECT`) sobre las tablas transaccionales y de control (`Auditoria_Precios`, `Venta_Factura`, `detalle_compra` y `pago`) para tareas de supervisión contable sin posibilidad de modificar datos.
* **¿Por qué fue elegido y cómo se integra al sistema?**  
  Protege la integridad operativa y financiera del comercio: un cajero puede consultar catálogos y registrar nuevas ventas a través del procedimiento transaccional, pero no puede borrar facturas emitidas ni manipular el historial de auditoría de precios.

---

## 5. Índices (Optimización de Consultas)

* **¿Para qué se utiliza?**  
  En el script [`sql/tecnico/optimizacionDatos.sql`](../../sql/tecnico/optimizacionDatos.sql) se crearon 5 índices no agrupados (`NONCLUSTERED INDEX`) orientados a acelerar las consultas y reportes desarrollados en la Etapa IV:
  1. `IX_VentaFactura_FechaHora` sobre `Venta_Factura (Fecha_hora)`: Optimiza los filtros por rango de fechas (`WHERE Fecha_hora BETWEEN ...`) utilizados en los reportes agregados de ventas mensuales y anuales.
  2. `IX_DetalleCompra_Producto` sobre `detalle_compra (Id_producto)`: Acelera los `JOIN` entre el detalle de ventas y el catálogo de productos, además de las agrupaciones por producto.
  3. `IX_DetalleCompra_Compra` sobre `detalle_compra (Id_compra)`: Como la clave primaria compuesta de `detalle_compra` es `(Id_producto, Id_compra)`, este índice secundario sobre `Id_compra` permite buscar de forma inmediata todos los renglones de una factura específica (`WHERE vf.Id_compra = 1`) sin recorrer toda la tabla (*Index Seek* en lugar de *Index Scan*).
  4. `IX_Pago_Compra` sobre `pago (Id_compra)`: Acelera la unión entre cada factura y su pago correspondiente, ya que la PK compuesta de `pago` inicia por `Id_metodo`.
  5. `IX_Producto_Categoria` sobre `Producto (Id_tipo_producto)`: Acelera el `JOIN` entre `Producto` y `Tipo_producto` en los reportes de recaudación por categoría.
* **Demostración de funcionamiento:**  
  Al ejecutar las consultas de la Etapa IV (Comprobante de Venta, Informe de Ventas por Fecha y Consulta Avanzada) activando `SET STATISTICS IO ON`, el optimizador de SQL Server utiliza operaciones de búsqueda por índice (`Index Seek`) sobre los índices creados en lugar de barridos completos de tabla (`Table/Index Scan`), reduciendo las lecturas lógicas de páginas de datos.
