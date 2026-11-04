
USE proyectoBDD2026;
GO

CREATE NONCLUSTERED INDEX IX_VentaFactura_FechaHora 
ON Venta_Factura (Fecha_hora);
GO


CREATE NONCLUSTERED INDEX IX_DetalleCompra_Producto 
ON detalle_compra (Id_producto);
GO

CREATE NONCLUSTERED INDEX IX_DetalleCompra_Compra 
ON detalle_compra (Id_compra);
GO


CREATE NONCLUSTERED INDEX IX_Pago_Compra 
ON pago (Id_compra);
GO


CREATE NONCLUSTERED INDEX IX_Producto_Categoria 
ON Producto (categoria);
GO