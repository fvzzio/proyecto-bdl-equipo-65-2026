
-- TRIGGER: AUDITORÍA DE BORRADO DE PRODUCTOS (DELETE)
USE proyectoBDD2026;
GO

IF COL_LENGTH('Auditoria_Precios', 'Accion') IS NULL
BEGIN
    ALTER TABLE Auditoria_Precios
    ADD Accion VARCHAR(20) NOT NULL DEFAULT 'MODIFICACION';
END
GO


CREATE OR ALTER TRIGGER trg_AuditarBorradoProducto
ON Producto
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Auditoria_Precios (Accion, Id_producto, Precio_Anterior, Precio_Nuevo, Usuario)
    SELECT
        'ELIMINACION',
        d.Id_producto,
        d.Precio_venta,
        NULL,
        SYSTEM_USER
    FROM DELETED d;
END;
GO


-- RESTRICCIÓN DE SEGURIDAD (Evitar borrados)
CREATE OR ALTER TRIGGER trg_EvitarBorradoProductoConVentas
ON Producto
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM deleted d
        INNER JOIN detalle_compra dc ON d.Id_producto = dc.Id_producto
    )
    BEGIN
        RAISERROR('Error crítico: No se puede eliminar un producto que posee registros de ventas históricos.', 16, 1);
        RETURN;
    END

    -- Si no tiene ventas asociadas, permitimos el borrado\
    DELETE FROM Producto
    WHERE Id_producto IN (SELECT Id_producto FROM deleted);
END;
GO



-- SCRIPTS DE PRUEBA


-- PRUEBA 1: Modificación de precio (Auditoría UPDATE)
DECLARE @PrecioOriginal INT = (SELECT Precio_venta FROM Producto WHERE Id_producto = 1);
UPDATE Producto SET Precio_venta = @PrecioOriginal + 500 WHERE Id_producto = 1;
SELECT * FROM Auditoria_Precios ORDER BY Id_auditoria DESC;

UPDATE Producto SET Precio_venta = @PrecioOriginal WHERE Id_producto = 1;
GO

-- PRUEBA 2: Borrado bloqueado (el producto 1 tiene ventas, debe dar el error del Trigger 3)
DELETE FROM Producto WHERE Id_producto = 1;
GO