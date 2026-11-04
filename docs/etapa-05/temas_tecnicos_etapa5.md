# Temas tecnicos implementados en la Etapa 5

En esta etapa agregamos distintos mecanismos en SQL Server sobre nuestra base de datos `proyectoBDD2026` para que el sistema del supermercado sea mas seguro, rapido y no queden datos incompletos cuando se registra una venta.

## Procedimiento almacenado y manejo de transacciones

Para registrar una venta completa creamos el procedimiento almacenado `sp_RegistrarVentaCompleta`. En lugar de hacer los `INSERT` sueltos uno por uno desde afuera, el procedimiento recibe como parametros los datos del cliente, el empleado, el tipo de factura, el metodo de pago, el importe, el producto y la cantidad.

Adentro del procedimiento usamos una transaccion (`BEGIN TRANSACTION`) junto con un bloque `TRY...CATCH`:
- Primero inserta la cabecera de la venta en `Venta_Factura`.
- Con `SCOPE_IDENTITY()` guarda el ID de la compra que se acaba de generar.
- Despues usa ese mismo ID para insertar los productos en `detalle_compra` y el cobro en la tabla `pago`.
- Si las tres tablas se cargan bien, hace `COMMIT TRANSACTION` y confirma todo. Si llega a fallar algo en el medio, entra al `CATCH` y ejecuta `ROLLBACK TRANSACTION` para volver todo atras y que no quede una factura creada sin pago o sin detalle.

Para probarlo en `Etap5_2.sql` ejecutamos:
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

## Funcion almacenada para descuento de clientes

Creamos la funcion `dbo.fn_CalcularDescuentoCliente` que recibe el `Id_cliente` y calcula que porcentaje de descuento le corresponde segun todo lo que llevo gastado en el negocio.

La funcion suma el `importeTotal` de la tabla `pago` unida con `Venta_Factura` para ese cliente:
- Si gasto 4000 o mas, devuelve `0.10` (10% de descuento).
- Si gasto entre 2000 y 3999, devuelve `0.05` (5% de descuento).
- Si gasto menos de 2000, devuelve `0.00`.

Se demuestra consultando la tabla `Cliente`:
```sql
SELECT 
    Id_cliente, 
    dbo.fn_CalcularDescuentoCliente(Id_cliente) AS PorcentajeDescuento
FROM Cliente;
```

## Trigger de auditoria de precios

Como en un comercio los precios de los productos se actualizan seguido, armamos una tabla llamada `Auditoria_Precios` y el trigger `trg_AuditarCambioPrecioProducto` sobre la tabla `Producto`.

El trigger se dispara automaticamente despues de un `UPDATE` (`AFTER UPDATE`). Con `IF UPDATE(Precio_venta)` revisa si se modifico el precio y guarda en `Auditoria_Precios` el ID del producto, el precio viejo (sacado de `DELETED`), el precio nuevo (sacado de `INSERTED`), la fecha con `GETDATE()` y el usuario que hizo el cambio (`SYSTEM_USER`).

Para probar su funcionamiento hicimos un cambio de precio en el producto 1 y consultamos la tabla de auditoria:
```sql
UPDATE Producto SET Precio_venta = 2500 WHERE Id_producto = 1;
SELECT * FROM Auditoria_Precios;
```

## Seguridad y roles de usuario

En el archivo `Seguridad.sql` separamos los permisos segun el rol que cumple cada persona en el sistema:

- **Rol_Vendedor:** Le dimos permisos de lectura (`GRANT SELECT`) sobre las tablas que necesita consultar en caja (`Producto`, `Metodo_pago`, `Tipo_factura`, `Cliente`) y permiso con `GRANT EXECUTE` para usar el procedimiento `sp_RegistrarVentaCompleta`. Al mismo tiempo le bloqueamos con `DENY` la posibilidad de borrar o modificar ventas ya hechas en `Venta_Factura` y tambien le prohibimos insertar, editar o borrar registros en `Auditoria_Precios`.
- **Rol_Auditor:** Le dimos unicamente permisos de lectura (`GRANT SELECT`) sobre `Auditoria_Precios`, `Venta_Factura`, `detalle_compra` y `pago` para que pueda revisar las ventas y los cambios de precios sin modificar los datos.

## Indices para optimizacion de consultas

En el archivo `optimizacionDatos.sql` agregamos cinco indices no agrupados (`NONCLUSTERED INDEX`) pensando en las consultas que hicimos en la Etapa 4:

- `IX_VentaFactura_FechaHora` en `Venta_Factura (Fecha_hora)`: para que busque mas rapido cuando filtramos ventas por rango de fechas en los reportes.
- `IX_DetalleCompra_Producto` en `detalle_compra (Id_producto)`: para agilizar los `JOIN` con la tabla `Producto`.
- `IX_DetalleCompra_Compra` en `detalle_compra (Id_compra)`: para encontrar rapido los renglones de una factura cuando armamos el comprobante de venta.
- `IX_Pago_Compra` en `pago (Id_compra)`: para unir mas rapido cada venta con su pago.
- `IX_Producto_Categoria` en `Producto (Id_tipo_producto)`: para acelerar los reportes agrupados por categoria de producto.
