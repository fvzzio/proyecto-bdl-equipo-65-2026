USE proyectoBDD2026;
GO
-- ==========================================================================================
-- 3. CONSULTA DE NEGOCIO AVANZADA (4 TABLAS + FILTRO DE GRUPO CON HAVING)
-- ==========================================================================================
SELECT 
    tp.Nombre_tipo AS [Categoría],
    pr.Descripcion AS [Producto],
    pr.Precio_venta AS [Precio Unitario],
    SUM(dc.cantidad) AS [Cantidad Total Vendida],
    SUM(dc.cantidad * pr.Precio_venta) AS [Ingreso Total Generado]
FROM detalle_compra dc
JOIN Producto pr ON dc.Id_producto = pr.Id_producto
JOIN Tipo_producto tp ON pr.Id_tipo_producto = tp.Id_tipo_producto
JOIN Venta_Factura v ON dc.Id_compra = v.Id_compra
GROUP BY tp.Nombre_tipo, pr.Descripcion, pr.Precio_venta
HAVING SUM(dc.cantidad) >= 1 -- Filtro de grupo avanzado
ORDER BY [Cantidad Total Vendida] DESC;
GO