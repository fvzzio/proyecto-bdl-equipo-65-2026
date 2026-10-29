# Implementacion fisica de la base de datos

## Introduccion

En esta etapa pasamos el diseño logico a una base de datos real en SQL Server. Todo el trabajo quedo dividido en dos scripts: uno que crea la estructura (DDL) y otro que carga los datos de prueba (DML). La base se llama `proyectoBDD2026`.

## Las tablas

Son 11 tablas en total. Cuatro son de catalogo y no dependen de nadie: `Puesto_Laboral`, `Tipo_producto`, `Metodo_pago` y `Tipo_factura`. Despues estan las entidades principales, que son `Cliente`, `Empleado`, `Producto` y `Proveedor`. Por ultimo estan las que registran las ventas: `Venta_Factura`, `pago` y `detalle_compra`.

`Empleado` depende de `Puesto_Laboral`, `Producto` depende de `Tipo_producto` y `Proveedor` depende de `Producto`. `Venta_Factura` depende de `Cliente`, `Empleado` y `Tipo_factura`. Las dos ultimas, `pago` y `detalle_compra`, son tablas intermedias con clave primaria compuesta: una venta puede pagarse con mas de un metodo de pago y puede tener varios productos, y a la vez un producto o un metodo aparece en muchas ventas.

## Tipos de datos

Algo que tuvimos que corregir del primer borrador fueron los tipos de datos, porque con los originales la base no hubiera funcionado bien.

Los `VARCHAR` no tenian longitud. En SQL Server un `VARCHAR` sin tamaño es en realidad un `VARCHAR(1)`, o sea que un nombre se cortaria a una sola letra. Por eso usamos `VARCHAR(50)` para nombres, apellidos y descripciones cortas, y `VARCHAR(100)` para las direcciones y la descripcion de los productos.

El telefono y el CUIT estaban como `INT`, pero un nemero de telefono de 10 digitos o un CUIT de 11 digitos es mas grande que el maximo de un `INT`, Entonces el telefono paso a `VARCHAR(15)` y el CUIT a `CHAR(11)`, porque siempre tiene 11 digitos. El DNI si lo dejamos como `INT` porque tiene 8 digitos y entra sin problema.

El precio de venta y el importe del pago los pasamos a `DECIMAL(10,2)` para poder guardar centavos sin errores de redondeo. Y `Fecha_hora` paso de `DATE` a `DATETIME`, porque el nombre del campo dice fecha y hora y con `DATE` se perdia la hora.

## Otros cambios respecto al script original

Ademas de los tipos de datos, hicimos estos cambios para que el script se pueda ejecutar:

- El constraint `fk_venta_factura` estaba repetido en `pago` y en `detalle_compra`. En SQL Server el nombre de un constraint tiene que ser unico, asi que el de `detalle_compra` lo renombramos a `fk_detalle_venta_factura`.
- Agregamos restricciones `UNIQUE` en los DNI, el CUIT y las descripciones de las tablas de catalogo.
- Le pusimos nombre a la clave primaria de `detalle_compra` (`pk_detalle_compra`), igual que en el resto de las tablas, y nombramos tambien la clave foranea que apunta a `Producto` (`fk_detalle_producto`).

## Carga de datos

El objetivo fue cargar 10 registros coherentes por tabla. Los inserts van en orden de dependencia: primero los catalogos y los clientes, despues empleados y productos, despues proveedores y ventas, y al final los detalles y los pagos. Si no se respeta ese orden las claves foraneas rechazan los datos.

Para que los datos sean coherentes, cada venta tiene sus productos en `detalle_compra` y su pago en `pago`, y el importe pagado coincide con la suma de cantidad por precio de los productos de esa venta. La venta 10 la dejamos pagada con dos metodos distintos a proposito, para probar que la clave compuesta de `pago` permite mas de un pago por venta. Por eso `pago` tiene 11 filas y `detalle_compra` tiene 19.
