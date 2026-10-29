# Comprobante de venta (Factura)

En esta parte resolvemos la consulta SQL que se encarga de armar la factura o ticket de venta. Como los datos del encabezado de la venta y los detalles de los productos estan guardados en tablas separadas, la idea de este script es juntar toda esa informacion en una sola salida limpia.

## Como esta armada la consulta

La consulta toma como base la tabla `Venta_Factura` y la va conectando mediante `INNER JOIN` con el resto de las tablas para recuperar los datos reales en lugar de los IDs.

Conectamos `Cliente` para sacar el nombre, apellido y DNI del comprador; `Empleado` para saber que cajero hizo la operacion; `Tipo_factura` para ver si es tipo A, B o C; y `pago` junto a `Metodo_pago` para mostrar como se pago. Para los productos, unimos `detalle_compra` con `Producto` para traer la descripcion, la cantidad y el precio de venta unitario.

## Los calculos

Para que la factura sea util, necesitamos dos calculos de dinero en el mismo resultado:

- **Subtotal del renglon:** Multiplicamos la cantidad por el precio unitario (`dc.cantidad * p.Precio_venta`). Esto nos da cuanto sale la cantidad comprada de ese producto en particular.
- **Total general de la factura:** Usamos la funcion de ventana `SUM(...) OVER(PARTITION BY vf.Id_compra)`. Esto lo que hace es sumar los subtotales de todos los productos que pertenecen a la misma venta sin necesidad de agrupar las filas, manteniendo el detalle de cada item pero mostrando el total final acumulado a un costado.

## Uso del filtro y formato

En el script le pusimos la condicion `WHERE vf.Id_compra = 1` para traer el comprobante de esa venta en especifico, pero cambiando ese numero sirve para cualquier compra del sistema.

Tambien le aplicamos `CONVERT` a la fecha para que aparezca con formato chileno/argentino (DD/MM/AAAA) y usamos `CONCAT` para unir nombres y apellidos en una sola columna para que quede mas prolijo.