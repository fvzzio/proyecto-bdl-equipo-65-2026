# Restricciones e integridad

## Claves primarias

Todas las tablas tienen clave primaria, que sirve para identificar cada fila y no permite nulos ni repetidos. En las tablas comunes la clave es un numero autoincremental (`IDENTITY`), por ejemplo `Id_cliente`, `Id_Empleado` o `Id_producto`.

Las dos tablas intermedias tienen clave primaria compuesta. En `pago` la clave es la combinacion de `Id_metodo` e `Id_compra`, lo que significa que una misma venta no puede tener dos pagos con el mismo metodo, pero si pagos con metodos distintos. En `detalle_compra` la clave es `Id_producto` mas `Id_compra`, o sea que un producto no se repite dos veces dentro de la misma venta (si se compran varias unidades, eso va en el campo `cantidad`).

## Claves foraneas

Las claves foraneas aseguran que las relaciones entre tablas sean validas. Por ejemplo, no se puede registrar una venta para un cliente que no existe, ni asignar a un empleado un puesto que no esta cargado. Las relaciones que definimos son estas:

- `Empleado` apunta a `Puesto_Laboral` (`fk_puesto_laboral`).
- `Producto` apunta a `Tipo_producto` (`fk_tipo_producto`).
- `Proveedor` apunta a `Producto` (`fk_producto`).
- `Venta_Factura` apunta a `Cliente`, `Empleado` y `Tipo_factura` (`fk_cliente`, `fk_empleado` y `fk_tipo_factura`).
- `pago` apunta a `Metodo_pago` y a `Venta_Factura` (`fk_metodo_pago` y `fk_venta_factura`).
- `detalle_compra` apunta a `Producto` y a `Venta_Factura` (`fk_detalle_producto` y `fk_detalle_venta_factura`).

En el script no escribimos reglas `ON DELETE` ni `ON UPDATE` de forma explicita. Cuando no se aclara nada, SQL Server usa `NO ACTION` para las dos. En la practica eso quiere decir que no se puede borrar un registro que tenga otros registros relacionados. Por ejemplo, no se puede borrar un cliente que ya tiene ventas, ni una venta que ya tiene pagos o detalles. Nos parecio razonable porque asi no se pierde el historial de ventas.

Una aclaracion sobre el `ON UPDATE`: como todas las claves primarias son `IDENTITY`, SQL Server no deja modificar su valor, asi que de todas formas esa regla nunca se llega a activar con esta base.

## Restricciones UNIQUE

Las usamos para evitar duplicados en datos que no deberian repetirse. El DNI es unico en `Cliente` y en `Empleado`, y el CUIT es unico en `Proveedor`, porque identifican a una persona o empresa real. Tambien son unicas las descripciones de `Puesto_Laboral`, `Tipo_producto`, `Metodo_pago`, `Tipo_factura` y `Producto`, para no tener por ejemplo dos puestos que se llamen igual.

## NOT NULL

Todos los campos estan definidos como `NOT NULL`, incluidas las claves foraneas. Esto significa que no puede existir una venta sin cliente, sin empleado o sin tipo de factura, y que todo producto tiene que tener precio y stock.

## Integridad de dominio

El tipo de dato tambien funciona como una restriccion. `DECIMAL(10,2)` limita los importes a dos decimales, `CHAR(11)` fija el largo del CUIT, y los `VARCHAR(n)` no dejan guardar textos mas largos que n caracteres (SQL Server da error en vez de cortarlos).

## Cosas que quedaron sin controlar

Hay algunas reglas que el script no valida y que serian una mejora a futuro. No hay `CHECK`, asi que la base aceptaria un precio negativo, un stock negativo o una cantidad igual a cero. Tampoco se controla que el telefono tenga solo numeros. Y la coherencia entre el importe de `pago` y la suma de los productos de la venta no esta forzada por ninguna restriccion, se puede revisar con una consulta (la incluimos en el documento de pruebas) pero para forzarla habria que usar un trigger.

Otra limitacion es de diseño: `Proveedor` tiene una sola clave foranea a `Producto`, entonces cada proveedor provee un solo producto. Si un proveedor tuviera que proveer varios productos haria falta una tabla intermedia.
