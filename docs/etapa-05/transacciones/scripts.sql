
-- ETAPA V - TRANSACCIONES 

USE proyectoBDD2026;
GO


-- prueba 1: se confirman venta, detalle, pago y stock

SELECT (SELECT COUNT(*) FROM Venta_Factura)  AS Ventas_Antes,
       (SELECT COUNT(*) FROM detalle_compra) AS Detalles_Antes,
       (SELECT COUNT(*) FROM pago)           AS Pagos_Antes,
       (SELECT stock FROM Producto WHERE Id_producto = 3) AS Stock_P3_Antes;

EXEC sp_RegistrarVentaCompleta
    @Id_cliente = 2, @Id_Empleado = 2, @Id_tipo_factura = 2, @Id_metodo = 1,
    @ImporteTotal = 2300, @Id_producto = 3, @Cantidad = 1;

SELECT (SELECT COUNT(*) FROM Venta_Factura)  AS Ventas_Despues,
       (SELECT COUNT(*) FROM detalle_compra) AS Detalles_Despues,
       (SELECT COUNT(*) FROM pago)           AS Pagos_Despues,
       (SELECT stock FROM Producto WHERE Id_producto = 3) AS Stock_P3_Despues;
GO

-- prueba 2: stock insuficiente -> el error revierte todo (nada cambia)

SELECT (SELECT COUNT(*) FROM Venta_Factura)  AS Ventas_Antes,
       (SELECT COUNT(*) FROM detalle_compra) AS Detalles_Antes,
       (SELECT COUNT(*) FROM pago)           AS Pagos_Antes,
       (SELECT stock FROM Producto WHERE Id_producto = 1) AS Stock_P1_Antes;

BEGIN TRY
    EXEC sp_RegistrarVentaCompleta
        @Id_cliente = 1, @Id_Empleado = 1, @Id_tipo_factura = 1, @Id_metodo = 1,
        @ImporteTotal = 2000000, @Id_producto = 1, @Cantidad = 1000;   -- mas que el stock
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS Error, ERROR_MESSAGE() AS Mensaje;
END CATCH;

SELECT (SELECT COUNT(*) FROM Venta_Factura)  AS Ventas_Despues,
       (SELECT COUNT(*) FROM detalle_compra) AS Detalles_Despues,
       (SELECT COUNT(*) FROM pago)           AS Pagos_Despues,
       (SELECT stock FROM Producto WHERE Id_producto = 1) AS Stock_P1_Despues;
GO


-- prueba 3: falla A MITAD del proceso (metodo de pago inexistente).
-- para ese momento ya se insertaron el encabezado y el detalle: el ROLLBACK los deshace.

SELECT (SELECT COUNT(*) FROM Venta_Factura)  AS Ventas_Antes,
       (SELECT COUNT(*) FROM detalle_compra) AS Detalles_Antes,
       (SELECT COUNT(*) FROM pago)           AS Pagos_Antes;

BEGIN TRY
    EXEC sp_RegistrarVentaCompleta
        @Id_cliente = 1, @Id_Empleado = 1, @Id_tipo_factura = 1, @Id_metodo = 999,
        @ImporteTotal = 2000, @Id_producto = 1, @Cantidad = 1;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS Error, ERROR_MESSAGE() AS Mensaje;
END CATCH;

SELECT (SELECT COUNT(*) FROM Venta_Factura)  AS Ventas_Despues,
       (SELECT COUNT(*) FROM detalle_compra) AS Detalles_Despues,
       (SELECT COUNT(*) FROM pago)           AS Pagos_Despues;
-- Los tres counts deben ser iguales a los de "Antes": no quedo una factura sin pago.
GO

-- prueba 4: cantidad invalida (0)

BEGIN TRY
    EXEC sp_RegistrarVentaCompleta
        @Id_cliente = 1, @Id_Empleado = 1, @Id_tipo_factura = 1, @Id_metodo = 1,
        @ImporteTotal = 0, @Id_producto = 1, @Cantidad = 0;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS Error, ERROR_MESSAGE() AS Mensaje;
END CATCH;
GO
