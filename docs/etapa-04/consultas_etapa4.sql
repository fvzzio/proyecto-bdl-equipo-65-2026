USE proyectoBDD2026;
GO

-- ==========================================================================================
-- 1. FACTURA / COMPROBANTE DE VENTA
-- Consolida encabezado y detalle, calculando subtotales y el total acumulado general.
-- ==========================================================================================
SELECT 
    vf.Id_compra AS Nro_Venta,
    tf.Descripcion AS Tipo_Comprobante,
    CONVERT(VARCHAR(10), vf.Fecha_hora, 103) AS Fecha,
    CONCAT(c.Nombre, ' ', c.Apellido) AS Cliente,
    c.DNI AS DNI_Cliente,
    CONCAT(e.Nombre, ' ', e.Apellido) AS Cajero,
    mp.Descripcion AS Medio_Pago,
    p.Descripcion AS Producto,
    dc.cantidad AS Cantidad,
    p.Precio_venta AS Precio_Unitario,
    (dc.cantidad * p.Precio_venta) AS Subtotal_Renglon,
    -- Total general acumulado de la venta (función de ventana)
    SUM(dc.cantidad * p.Precio_venta) OVER(PARTITION BY vf.Id_compra) AS Total_Factura_Acumulado
FROM Venta_Factura vf
INNER JOIN Cliente c ON vf.Id_cliente = c.Id_cliente
INNER JOIN Empleado e ON vf.Id_Empleado = e.Id_Empleado
INNER JOIN Tipo_factura tf ON vf.Id_tipo_factura = tf.Id_tipo_factura
INNER JOIN pago pg ON vf.Id_compra = pg.Id_compra
INNER JOIN Metodo_pago mp ON pg.Id_metodo = mp.Id_metodo
INNER JOIN detalle_compra dc ON vf.Id_compra = dc.Id_compra
INNER JOIN Producto p ON dc.Id_producto = p.Id_producto
WHERE vf.Id_compra = 1
ORDER BY p.Id_producto ASC;
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
