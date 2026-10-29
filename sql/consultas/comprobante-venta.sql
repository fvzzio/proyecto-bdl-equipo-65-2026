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