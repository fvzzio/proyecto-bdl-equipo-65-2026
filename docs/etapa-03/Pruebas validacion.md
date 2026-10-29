# Pruebas de validación

## Cómo hicimos las pruebas

Después de ejecutar el DDL y el DML probamos la base en SQL Server para comprobar que todo funcionara como esperaba. Las pruebas las hicimos directamente en una ventana de consulta nueva, usando la base `proyectoBDD2026`. Primero revisamos que los datos estuvieran bien cargados y después probamos que las restricciones rechazaran los datos incorrectos.

## Revisión de los datos cargados

Lo primero que hicimos fue contar los registros de cada tabla con un `SELECT COUNT(*)`, para ver que los inserts se hubieran ejecutado completos. El resultado esperado era de 10 filas en cada tabla, menos en `detalle_compra`, que tiene 19 porque cada venta tiene uno o dos productos, y en `pago`, que tiene 11 porque la venta 10 se pagó con dos métodos distintos.

Después comprobamos que los datos fueran coherentes entre sí. Hice una consulta que suma, para cada venta, la cantidad por el precio de cada producto y la compara con lo que se pagó en la tabla `pago`. No devolvió ninguna fila, lo que quiere decir que todos los importes coinciden. También hicimos un `SELECT` con `JOIN` entre `Venta_Factura`, `Cliente`, `Empleado`, `Tipo_factura`, `detalle_compra` y `Producto`, y devolvió 19 filas, una por cada producto vendido. Esto sirvió para confirmar que no había registros apuntando a datos que no existen.

## Pruebas de las restricciones

Para probar las restricciones intentamos a propósito cargar datos que no deberían aceptarse, y verifiqué que SQL Server diera error en cada caso.

Con las claves únicas probamos insertar un cliente con un DNI que ya estaba cargado y un proveedor con un CUIT repetido. En los dos casos dio el error 2627, que corresponde a una violación de `UNIQUE`.

Con el `NOT NULL` intenté insertar un cliente sin nombre y dio el error 515, que avisa que no se puede guardar un valor nulo en esa columna.

Para el tamaño de los campos probé insertar un nombre de 60 letras en una columna de `VARCHAR(50)`, y SQL Server lo rechazó con el error 2628 en lugar de cortar el texto.

Con las claves foráneas probamos dos cosas. Primero intenté insertar un empleado con un puesto que no existe, por ejemplo el 999, y dio error 547. Después intenté borrar un cliente que ya tenía ventas y un producto que ya se había vendido, y también dio error 547. Esto confirma que no se pueden dejar registros huérfanos. Algo parecido pasó al intentar borrar una venta que tiene pagos y detalles: como no definimos borrado en cascada, SQL Server no lo permite hasta que se borren primero esas filas.

Por último probamos la clave primaria compuesta de `pago`. Intenté cargar otro pago con el mismo método para la misma venta y dio el error 2627. En cambio, la venta 10, que tiene dos pagos con métodos diferentes, se cargó sin problemas, que es justo lo que buscaba con esa clave.

## Qué no se probó

No hicimos pruebas de valores negativos en el precio o el stock ni de teléfonos con letras, porque en el script no definí restricciones `CHECK` y la base todavía los aceptaría. Tampoco probamos el `ON UPDATE`, ya que las claves son `IDENTITY` y SQL Server no permite modificarlas.

## Conclusión

Las pruebas salieron como esperaba. Los datos se cargaron completos y son coherentes, y las claves primarias, las claves foráneas, los `UNIQUE`, los `NOT NULL` y los tipos de datos rechazaron los valores incorrectos con el error que correspondía.
