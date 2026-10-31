USE proyectoBDD2026;
GO


IF NOT EXISTS (SELECT * FROM Tipo_factura WHERE Id_tipo_factura = 1)
BEGIN
    INSERT INTO Tipo_factura (Descripcion) VALUES ('Factura A');
END


EXEC sp_RegistrarVentaCompleta 
    @Id_cliente = 1, 
    @Id_Empleado = 1, 
    @Id_tipo_factura = 1, 
    @Id_metodo = 1, 
    @ImporteTotal = 4000, 
    @Id_producto = 1, 
    @Cantidad = 2;


SELECT * FROM Venta_Factura;
SELECT * FROM detalle_compra;
SELECT * FROM pago;


UPDATE Producto SET Precio_venta = 2500 WHERE Id_producto = 1;


SELECT * FROM Auditoria_Precios;