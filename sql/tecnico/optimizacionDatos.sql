USE proyectoBDD2026;
GO

DROP INDEX IF EXISTS IX_VentaFactura_FechaHora ON Venta_Factura;
GO
CREATE NONCLUSTERED INDEX IX_VentaFactura_FechaHora
ON Venta_Factura (Fecha_hora);
GO

DROP INDEX IF EXISTS IX_DetalleCompra_Producto ON detalle_compra;
GO
CREATE NONCLUSTERED INDEX IX_DetalleCompra_Producto
ON detalle_compra (Id_producto);
GO

DROP INDEX IF EXISTS IX_DetalleCompra_Compra ON detalle_compra;
GO
CREATE NONCLUSTERED INDEX IX_DetalleCompra_Compra
ON detalle_compra (Id_compra);
GO

DROP INDEX IF EXISTS IX_Pago_Compra ON pago;
GO
CREATE NONCLUSTERED INDEX IX_Pago_Compra
ON pago (Id_compra);
GO

DROP INDEX IF EXISTS IX_Producto_Categoria ON Producto;
GO
CREATE NONCLUSTERED INDEX IX_Producto_Categoria
ON Producto (Id_tipo_producto);
GO
