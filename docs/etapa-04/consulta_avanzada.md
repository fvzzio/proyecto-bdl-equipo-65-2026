# Consulta de negocio avanzada

En esta etapa armamos una consulta mas avanzada que cruza informacion de 4 tablas distintas del sistema. El objetivo es analizar el comportamiento de cada producto individual dentro de su categoria y evaluar su nivel de rotacion e ingresos.

## Como funciona la consulta

Para armar este reporte unimos las tablas `detalle_compra`, `Producto`, `Tipo_producto` y `Venta_Factura`.

Agrupamos los datos por la categoria (`Nombre_tipo`), la descripcion del producto y su precio unitario (`GROUP BY tp.Nombre_tipo, pr.Descripcion, pr.Precio_venta`). Esto nos permite calcular la cantidad total vendida de cada item individual mediante `SUM(dc.cantidad)` y el ingreso acumulado que genero multiplicando esa cantidad por su precio.

## Filtro de grupos con HAVING

La diferencia clave de esta consulta respecto a un filtro comun es que usamos la clausula `HAVING`.

El `WHERE` sirve para filtrar filas individuales antes de agruparlas, pero como nosotros queriamos filtrar el resultado de una suma ya agrupada, tuvimos que usar `HAVING SUM(dc.cantidad) >= 1`. Con esta condicion le decimos a SQL Server que solo nos devuelva los productos que sumen 1 o mas unidades vendidas en total, dejando afuera los productos que no registraron movimiento.

## Ordenamiento del resultado

Para cerrar la consulta le pusimos un `ORDER BY [Cantidad Total Vendida] DESC`. De esta forma la salida nos muestra arriba los productos estrella o mas vendidos del comercio, lo que ayuda a la toma de decisiones para reponer stock o armar promociones.