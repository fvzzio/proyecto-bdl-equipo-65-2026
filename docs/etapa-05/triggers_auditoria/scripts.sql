
-- ETAPA V - TRIGGER DE AUDITORIA DE PRECIOS

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

-- Se ejecuta automaticamente despues de un UPDATE sobre Producto.
-- Solo registra cuando el precio realmente cambio (valor anterior / valor nuevo).
CREATE OR ALTER TRIGGER trg_AuditarCambioPrecioProducto
ON Producto
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Precio_venta)
    BEGIN
        INSERT INTO Auditoria_Precios (Id_producto, Precio_Anterior, Precio_Nuevo, Usuario)
        SELECT
            i.Id_producto,
            d.Precio_venta,
            i.Precio_venta,
            SYSTEM_USER
        FROM INSERTED i
        INNER JOIN DELETED d ON i.Id_producto = d.Id_producto
        WHERE i.Precio_venta <> d.Precio_venta;
    END
END;
GO


-- prueba: modificar el precio del producto 1 y consultar la tabla de auditoria
-- (el precio se restaura para no afectar a la etapa 4)

DECLARE @PrecioOriginal INT = (SELECT Precio_venta FROM Producto WHERE Id_producto = 1);

SELECT Id_producto, Descripcion, Precio_venta AS PrecioAntes FROM Producto WHERE Id_producto = 1;

UPDATE Producto SET Precio_venta = @PrecioOriginal + 500 WHERE Id_producto = 1;

SELECT Id_producto, Descripcion, Precio_venta AS PrecioDespues FROM Producto WHERE Id_producto = 1;
SELECT * FROM Auditoria_Precios ORDER BY Id_auditoria DESC;

-- Restaurar el precio
UPDATE Producto
SET Precio_venta = (SELECT TOP 1 Precio_Anterior FROM Auditoria_Precios
                    WHERE Id_producto = 1 ORDER BY Id_auditoria DESC)
WHERE Id_producto = 1;
SELECT * FROM Auditoria_Precios ORDER BY Id_auditoria DESC;
GO

