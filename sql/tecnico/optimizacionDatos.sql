USE proyectoBDD2026;
GO

-- 1. Índice para búsquedas por fecha en Venta_Factura
DROP INDEX IF EXISTS IX_VentaFactura_FechaHora ON Venta_Factura;
GO
CREATE NONCLUSTERED INDEX IX_VentaFactura_FechaHora
ON Venta_Factura (Fecha_hora);
GO

-- 2. Índice para acelerar uniones en detalle_compra con Producto
DROP INDEX IF EXISTS IX_DetalleCompra_Producto ON detalle_compra;
GO
CREATE NONCLUSTERED INDEX IX_DetalleCompra_Producto
ON detalle_compra (Id_producto);
GO

-- 3. Índice para acelerar uniones en detalle_compra con Venta_Factura
DROP INDEX IF EXISTS IX_DetalleCompra_Compra ON detalle_compra;
GO
CREATE NONCLUSTERED INDEX IX_DetalleCompra_Compra
ON detalle_compra (Id_compra);
GO

-- 4. Índice para acelerar pagos por compra
DROP INDEX IF EXISTS IX_Pago_Compra ON pago;
GO
CREATE NONCLUSTERED INDEX IX_Pago_Compra
ON pago (Id_compra);
GO

-- 5. Índice para acelerar búsqueda por categoría en Producto
DROP INDEX IF EXISTS IX_Producto_Categoria ON Producto;
GO
CREATE NONCLUSTERED INDEX IX_Producto_Categoria
ON Producto (Id_tipo_producto);
GO
