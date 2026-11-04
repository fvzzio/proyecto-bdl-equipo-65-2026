USE proyectoBDD2026;
GO


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Auditoria_Precios')
BEGIN
    CREATE TABLE Auditoria_Precios (
        Id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
        Id_producto INT,
        Precio_Anterior INT,
        Precio_Nuevo INT,
        Fecha_Modificacion DATETIME DEFAULT GETDATE(),
        Usuario VARCHAR(100)
    );
END
GO


CREATE OR ALTER PROCEDURE sp_RegistrarVentaCompleta
    @Id_cliente INT,
    @Id_Empleado INT,
    @Id_tipo_factura INT,
    @Id_metodo INT,
    @ImporteTotal INT,
    @Id_producto INT,
    @Cantidad INT
AS
BEGIN
    BEGIN TRANSACTION;
    
    BEGIN TRY
        INSERT INTO Venta_Factura (Fecha_hora, Id_cliente, Id_Empleado, Id_tipo_factura)
        VALUES (GETDATE(), @Id_cliente, @Id_Empleado, @Id_tipo_factura);
        
        DECLARE @Id_compra INT = SCOPE_IDENTITY();
        
        INSERT INTO detalle_compra (cantidad, Id_producto, Id_compra)
        VALUES (@Cantidad, @Id_producto, @Id_compra);
        
        INSERT INTO pago (importeTotal, Id_metodo, Id_compra)
        VALUES (@ImporteTotal, @Id_metodo, @Id_compra);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


CREATE OR ALTER TRIGGER trg_AuditarCambioPrecioProducto
ON Producto
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Precio_venta)
    BEGIN
        INSERT INTO Auditoria_Precios (Id_producto, Precio_Anterior, Precio_Nuevo, Usuario)
        SELECT 
            i.Id_producto,
            d.Precio_venta,
            i.Precio_venta,
            SYSTEM_USER
        FROM INSERTED i
        INNER JOIN DELETED d ON i.Id_producto = d.Id_producto;
    END
END;
GO