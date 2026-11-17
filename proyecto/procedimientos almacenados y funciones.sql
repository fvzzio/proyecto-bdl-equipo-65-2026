
-- ETAPA V: PROCEDIMIENTOS ALMACENADOS Y FUNCIONES


USE proyectoBDD2026;
GO

-- Función 1: Stock disponible de un producto
CREATE OR ALTER FUNCTION dbo.fn_StockDisponible (@Id_producto INT)
RETURNS INT
AS
BEGIN
    RETURN ISNULL((SELECT stock FROM Producto WHERE Id_producto = @Id_producto), 0);
END;
GO

-- Función 2: Descuento del cliente según volumen histórico acumulado
CREATE OR ALTER FUNCTION dbo.fn_CalcularDescuentoCliente (@Id_cliente INT)
RETURNS DECIMAL(4,2)
AS
BEGIN
    DECLARE @TotalGastado BIGINT;

    SELECT @TotalGastado = ISNULL(SUM(p.importeTotal), 0)
    FROM pago p
    INNER JOIN Venta_Factura v ON p.Id_compra = v.Id_compra
    WHERE v.Id_cliente = @Id_cliente;

    RETURN CASE
               WHEN @TotalGastado >= 4000 THEN 0.10
               WHEN @TotalGastado >= 2000 THEN 0.05
               ELSE 0.00
           END;
END;
GO

-- Función 3: Cantidad total de compras realizadas por un cliente
CREATE OR ALTER FUNCTION dbo.fn_TotalVentasCliente (@Id_cliente INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM Venta_Factura WHERE Id_cliente = @Id_cliente);
END;
GO


-- 2.1 Alta de Cliente
CREATE OR ALTER PROCEDURE sp_InsertarCliente
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @DNI VARCHAR(11),
    @Telefono VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Cliente (Nombre, Apellido, DNI, Num_telefono)
    VALUES (@Nombre, @Apellido, @DNI, @Telefono);
END;
GO

-- 2.2 Modificación de Cliente
CREATE OR ALTER PROCEDURE sp_ModificarCliente
    @Id_cliente INT,
    @Telefono VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Cliente
    SET Num_telefono = @Telefono
    WHERE Id_cliente = @Id_cliente;
END;
GO

-- 2.3 Baja de Cliente
CREATE OR ALTER PROCEDURE sp_EliminarCliente
    @Id_cliente INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Cliente
    WHERE Id_cliente = @Id_cliente;
END;
GO



-- 3. PROCEDIMIENTO TRANSACCIONAL COMPLEJO


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
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Cantidad IS NULL OR @Cantidad <= 0
            THROW 50002, 'La cantidad debe ser mayor a cero', 1;

        IF dbo.fn_StockDisponible(@Id_producto) < @Cantidad
            THROW 50001, 'Stock insuficiente', 1;

        INSERT INTO Venta_Factura (Fecha_hora, Id_cliente, Id_Empleado, Id_tipo_factura)
        VALUES (GETDATE(), @Id_cliente, @Id_Empleado, @Id_tipo_factura);

        DECLARE @Id_compra INT = SCOPE_IDENTITY();

        INSERT INTO detalle_compra (cantidad, Id_producto, Id_compra)
        VALUES (@Cantidad, @Id_producto, @Id_compra);

        INSERT INTO pago (importeTotal, Id_metodo, Id_compra)
        VALUES (@ImporteTotal, @Id_metodo, @Id_compra);

        UPDATE Producto
        SET stock = stock - @Cantidad
        WHERE Id_producto = @Id_producto
          AND stock >= @Cantidad;

        IF @@ROWCOUNT = 0
            THROW 50001, 'Stock insuficiente', 1;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO



-- 4. PRUEBAS Y COMPARACIÓN DE RENDIMIENTO (INSERT vs Procedimiento)


-- Probar funciones nuevas
SELECT Id_cliente, Nombre, dbo.fn_TotalVentasCliente(Id_cliente) AS Total_Compras FROM Cliente;

-- Activación del medidor de tiempo para comparar rendimiento
SET STATISTICS TIME ON;
GO

-- A. Inserción directa tradicional (INSERT)
INSERT INTO Cliente (Nombre, Apellido, DNI, Num_telefono)
VALUES ('TestComun', 'Prueba', '99887766', '3794111111');
GO

-- B. Inserción a través del Procedimiento Almacenado (EXEC)
EXEC sp_InsertarCliente
    @Nombre = 'Pedro',
    @Apellido = 'Sanchez',
    @DNI = '99887755',
    @Telefono = '3794222222';
GO

SET STATISTICS TIME OFF;
GO