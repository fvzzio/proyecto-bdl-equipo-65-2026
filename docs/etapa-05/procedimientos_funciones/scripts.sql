
-- ETAPA V - PROCEDIMIENTOS ALMACENADOS Y FUNCIONES

USE proyectoBDD2026;
GO


-- FUNCION 1: stock disponible de un producto (la usa el procedimiento para validar)

CREATE OR ALTER FUNCTION dbo.fn_StockDisponible (@Id_producto INT)
RETURNS INT
AS
BEGIN
    RETURN ISNULL((SELECT stock FROM Producto WHERE Id_producto = @Id_producto), 0);
END;
GO

-- FUNCION 2: descuento del cliente segun lo acumulado en compras

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


-- PROCEDIMIENTO:
-- 1) valida cantidad y stock 
-- 3) inserta detalle           
-- 4) inserta pago
-- 5) descuenta el stock del producto

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

        -- La condicion stock >= @Cantidad evita dejar el stock en negativo
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

-- Prueba 1: funcion de descuento para todos los clientes
SELECT Id_cliente,
       dbo.fn_CalcularDescuentoCliente(Id_cliente) AS PorcentajeDescuento
FROM Cliente;
GO

-- Prueba 2: funcion de stock
SELECT Id_producto, Descripcion, stock,
       dbo.fn_StockDisponible(Id_producto) AS StockDisponible
FROM Producto
WHERE Id_producto = 2;
GO

-- Prueba 3: ejecucion exitosa del procedimiento (stock ANTES -> DESPUES)
SELECT Id_producto, stock AS StockAntes FROM Producto WHERE Id_producto = 1;

EXEC sp_RegistrarVentaCompleta
    @Id_cliente = 1,
    @Id_Empleado = 1,
    @Id_tipo_factura = 1,
    @Id_metodo = 1,
    @ImporteTotal = 4000,
    @Id_producto = 1,
    @Cantidad = 2;

SELECT Id_producto, stock AS StockDespues FROM Producto WHERE Id_producto = 1;

-- Venta recien creada con su detalle y su pago
SELECT TOP 1 * FROM Venta_Factura ORDER BY Id_compra DESC;
SELECT * FROM detalle_compra WHERE Id_compra = (SELECT MAX(Id_compra) FROM Venta_Factura);
SELECT * FROM pago          WHERE Id_compra = (SELECT MAX(Id_compra) FROM Venta_Factura);
GO
