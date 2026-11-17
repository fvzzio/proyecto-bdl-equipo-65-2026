USE proyectoBDD2026;
GO


-- 1. TABLA DE PRUEBA SIN ÍNDICES

-- Es una copia de Venta_Factura

DROP TABLE IF EXISTS Venta_Factura_Prueba;
GO

CREATE TABLE Venta_Factura_Prueba
(
    Id_compra       INT IDENTITY(1,1),
    Fecha_hora      DATE,
    Id_cliente      INT,
    Id_Empleado     INT,
    Id_tipo_factura INT
);
GO



-- 2. CARGA DE 1M DE REGISTROS


DECLARE @i INT = 1;

BEGIN TRANSACTION;
WHILE @i <= 1000000
BEGIN
    INSERT INTO Venta_Factura_Prueba (Fecha_hora, Id_cliente, Id_Empleado, Id_tipo_factura)
    VALUES (
        DATEADD(day, -(@i % 365), GETDATE()),  -- fechas del último año
        (@i % 5) + 1,                          -- clientes del 1 al 5
        (@i % 2) + 1,                          -- empleados 1 y 2
        1
    );
    SET @i = @i + 1;
END;
COMMIT TRANSACTION;
GO

-- Comprobamos que se cargó el millón
SELECT COUNT(*) AS TotalRegistros FROM Venta_Factura_Prueba;
GO



-- 3. PRUEBAS: LA MISMA BÚSQUEDA EN TRES SITUACIONES


-- Los tiempos y lecturas aparecen en la pestaña "Mensajes".

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

-- PRUEBA 1: SIN INDICE
SELECT Id_compra, Fecha_hora, Id_cliente, Id_Empleado
FROM Venta_Factura_Prueba
WHERE Fecha_hora >= DATEADD(month, -3, GETDATE());
GO


-- PRUEBA 2: CON INDICE AGRUPADO SOBRE LA FECHA
CREATE CLUSTERED INDEX IX_Fecha_Agrupado
ON Venta_Factura_Prueba (Fecha_hora);
GO

SELECT Id_compra, Fecha_hora, Id_cliente, Id_Empleado
FROM Venta_Factura_Prueba
WHERE Fecha_hora >= DATEADD(month, -3, GETDATE());
GO

-- Borramos el  Indice para probar el siguiente
DROP INDEX IX_Fecha_Agrupado ON Venta_Factura_Prueba;
GO


-- PRUEBA 3: CON INDICE SOBRE LA FECHA QUE INCLUYE LAS COLUMNAS QUE PEDIMOS
CREATE NONCLUSTERED INDEX IX_Fecha_Incluye
ON Venta_Factura_Prueba (Fecha_hora)
INCLUDE (Id_compra, Id_cliente, Id_Empleado);
GO

SELECT Id_compra, Fecha_hora, Id_cliente, Id_Empleado
FROM Venta_Factura_Prueba
WHERE Fecha_hora >= DATEADD(month, -3, GETDATE());
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO



-- 4. ÍNDICES PARA LAS TABLAS REALES DEL SISTEMA

-- Solo se crean si todavía no existen.

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_VentaFactura_FechaHora')
    CREATE NONCLUSTERED INDEX IX_VentaFactura_FechaHora ON Venta_Factura (Fecha_hora);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DetalleCompra_Producto')
    CREATE NONCLUSTERED INDEX IX_DetalleCompra_Producto ON detalle_compra (Id_producto);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DetalleCompra_Compra')
    CREATE NONCLUSTERED INDEX IX_DetalleCompra_Compra ON detalle_compra (Id_compra);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Pago_Compra')
    CREATE NONCLUSTERED INDEX IX_Pago_Compra ON pago (Id_compra);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Producto_Categoria')
    CREATE NONCLUSTERED INDEX IX_Producto_Categoria ON Producto (Id_tipo_producto);
GO

/* 5. RESULTADOS Y CONCLUSIONES

 | Prueba                     | Tiempo (ms) |
 |----------------------------|-------------|
 | 1. Sin índice              |     870     |
 | 2. Índice agrupado         |     867     |
 | 3. Índice con INCLUDE      |     865     |

 Conclusiones:
 1. Sin índice, el motor revisa todos los registros, aunque solo necesite
    los de los últimos 3 meses. Es lo más lento.
 2. Con el índice agrupado, la tabla queda ordenada por fecha y el motor
    va directo al período buscado. Lee menos y tarda menos.
 3. Con el índice que incluye las columnas, el motor encuentra todo lo que
    necesita dentro del propio índice. Suele ser lo más rápido.
 4. Los índices ayudan a las consultas de lectura, pero ocupan espacio y
    hacen un poco más lentas las altas y modificaciones. Conviene crear
    solo los que se necesitan.

*/
/*
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
GO