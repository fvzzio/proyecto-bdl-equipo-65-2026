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

SELECT * FROM Auditoria_Precios;
SELECT * FROM Tipo_factura;



SELECT 
    Id_cliente, 
    dbo.fn_CalcularDescuentoCliente(Id_cliente) AS PorcentajeDescuento
FROM Cliente;

GO

CREATE OR ALTER FUNCTION dbo.fn_CalcularDescuentoCliente (@Id_cliente INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @TotalGastado DECIMAL(18,2);
    DECLARE @Descuento DECIMAL(5,2) = 0.00;

    SELECT @TotalGastado = ISNULL(SUM(p.importeTotal), 0)
    FROM Venta_Factura vf
    INNER JOIN pago p ON vf.Id_compra = p.Id_compra
    WHERE vf.Id_cliente = @Id_cliente;

    IF @TotalGastado >= 4000
        SET @Descuento = 0.10;
    ELSE IF @TotalGastado >= 2000
        SET @Descuento = 0.05;
    ELSE
        SET @Descuento = 0.00;

    RETURN @Descuento;
END;
GO

SELECT 
    Id_cliente, 
    dbo.fn_CalcularDescuentoCliente(Id_cliente) AS PorcentajeDescuento
FROM Cliente;