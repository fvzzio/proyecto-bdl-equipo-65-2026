# Informe de ventas en rango de fechas

En este script armamos las consultas para generar los reportes agregados que necesita la administracion. El objetivo es analizar el rendimiento del negocio durante un periodo de tiempo determinado, en este caso filtrando por todo el ano 2026. Dividimos el informe en dos partes: una para ver como vendio cada empleado y otra para ver como rindio cada categoria de producto.

## Reporte por vendedor / empleado

En la primera consulta agrupamos las ventas por el nombre y apellido del vendedor usando `GROUP BY`. 

Para medir el rendimiento usamos dos funciones de agregacion:
- `COUNT(DISTINCT v.Id_compra)` para contar cuantas ventas unicas realizo cada empleado en ese periodo. Usamos `DISTINCT` para que si una venta tiene varios pagos o productos no la cuente dos veces.
- `SUM(p.importeTotal)` para calcular el dinero total que recaudo cada vendedor.

Filtramos con `WHERE v.Fecha_hora BETWEEN '2026-01-01' AND '2026-12-31'` para acotar el reporte al ano deseado, y ordenamos el resultado con `ORDER BY` de forma descendente para que arriba de todo aparezca el empleado que mas dinero le genero al negocio.

## Reporte por categoria de producto

En la segunda consulta cruzamos la tabla `Tipo_producto` con `Producto`, `detalle_compra` y `Venta_Factura`.

Aca agrupamos por el nombre del tipo de producto y calculamos:
- `SUM(dc.cantidad)` para saber el total de unidades vendidas que tuvo esa categoria.
- `SUM(dc.cantidad * pr.Precio_venta)` para calcular el volumen total de dinero facturado por cada tipo de producto.

Al igual que en la consulta anterior, aplicamos el filtro por rango de fechas en la venta y ordenamos de mayor a menor segun la recaudacion total. Esto permite saber de un vistazo cual es el rubro mas lucrativo del negocio.