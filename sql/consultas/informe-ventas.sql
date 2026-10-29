USE proyectoBDD2026;
GO
-- ==========================================================================================
-- 2. REPORTE AGREGADO EN RANGO DE FECHAS
-- ==========================================================================================

-- 2A. Reporte por Vendedor / Empleado
SELECT 
    e.Nombre + ' ' + e.Apellido AS [Vendedor],
    COUNT(DISTINCT v.Id_compra) AS [Total de Ventas Realizadas],
    SUM(p.importeTotal) AS [Recaudación Total en el Periodo]
FROM Empleado e
JOIN Venta_Factura v ON e.Id_Empleado = v.Id_Empleado
JOIN pago p ON v.Id_compra = p.Id_compra
WHERE v.Fecha_hora BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY e.Nombre, e.Apellido
ORDER BY [Recaudación Total en el Periodo] DESC;
GO

-- 2B. Reporte por Categoría de Producto
SELECT 
    tp.Nombre_tipo AS [Categoría de Producto],
    SUM(dc.cantidad) AS [Unidades Vendidas],
    SUM(dc.cantidad * pr.Precio_venta) AS [Recaudación por Categoría]
FROM Tipo_producto tp
JOIN Producto pr ON tp.Id_tipo_producto = pr.Id_tipo_producto
JOIN detalle_compra dc ON pr.Id_producto = dc.Id_producto
JOIN Venta_Factura v ON dc.Id_compra = v.Id_compra
WHERE v.Fecha_hora BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY tp.Nombre_tipo
ORDER BY [Recaudación por Categoría] DESC;
GO