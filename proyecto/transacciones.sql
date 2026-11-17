-- ETAPA V - TRANSACCIONES 


USE proyectoBDD2026;
GO


-- prueba 1: transacción con todos los pasos correctos -> se guarda
-- pasos: crear la venta, cargar el detalle, cargar el pago y bajar el stock

SELECT (SELECT COUNT(*) FROM Venta_Factura)  AS Ventas_Antes,
       (SELECT COUNT(*) FROM detalle_compra) AS Detalles_Antes,
       (SELECT COUNT(*) FROM pago)           AS Pagos_Antes,
       (SELECT stock FROM Producto WHERE Id_producto = 3) AS Stock_P3_Antes;

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Venta_Factura (Fecha_hora, Id_cliente, Id_Empleado, Id_tipo_factura)
    VALUES (GETDATE(), 2, 2, 2);

    DECLARE @IdVenta INT;
    SET @IdVenta = SCOPE_IDENTITY();   -- número de la venta que se acaba de crear

    INSERT INTO detalle_compra (cantidad, Id_producto, Id_compra)
    VALUES (1, 3, @IdVenta);

    INSERT INTO pago (importeTotal, Id_metodo, Id_compra)
    VALUES (2300, 1, @IdVenta);

    UPDATE Producto SET stock = stock - 1 WHERE Id_producto = 3;

    COMMIT TRANSACTION;   -- recién acá se guardan todos los cambios
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT ERROR_MESSAGE() AS Mensaje;
END CATCH;

SELECT (SELECT COUNT(*) FROM Venta_Factura)  AS Ventas_Despues,
       (SELECT COUNT(*) FROM detalle_compra) AS Detalles_Despues,
       (SELECT COUNT(*) FROM pago)           AS Pagos_Despues,
       (SELECT stock FROM Producto WHERE Id_producto = 3) AS Stock_P3_Despues;
-- Ventas, detalles y pagos suben en 1 y el stock baja en 1.
GO


-- prueba 2: provocar un error despues del insert

SELECT (SELECT COUNT(*) FROM Venta_Factura)  AS Ventas_Antes,
       (SELECT COUNT(*) FROM detalle_compra) AS Detalles_Antes,
       (SELECT COUNT(*) FROM pago)           AS Pagos_Antes,
       (SELECT stock FROM Producto WHERE Id_producto = 1) AS Stock_P1_Antes;

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Venta_Factura (Fecha_hora, Id_cliente, Id_Empleado, Id_tipo_factura)
    VALUES (GETDATE(), 1, 1, 1);

    DECLARE @IdVenta INT;
    SET @IdVenta = SCOPE_IDENTITY();

    INSERT INTO detalle_compra (cantidad, Id_producto, Id_compra)
    VALUES (1, 1, @IdVenta);

    INSERT INTO pago (importeTotal, Id_metodo, Id_compra)
    VALUES (2000, 999, @IdVenta);   -- el método 999 no existe

    UPDATE Producto SET stock = stock - 1 WHERE Id_producto = 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;   -- deshace la venta y el detalle que ya se habían cargado
    SELECT ERROR_MESSAGE() AS Mensaje;
END CATCH;

SELECT (SELECT COUNT(*) FROM Venta_Factura)  AS Ventas_Despues,
       (SELECT COUNT(*) FROM detalle_compra) AS Detalles_Despues,
       (SELECT COUNT(*) FROM pago)           AS Pagos_Despues,
       (SELECT stock FROM Producto WHERE Id_producto = 1) AS Stock_P1_Despues;
-- Todo debe quedar igual que en antes 
GO


-- prueba 3: transacciones anidadas (una transacción dentro de otra)
-- el COMMIT de la de adentro todavía no guarda nada: solo guarda el de la de afuera.
-- si la de afuera hace ROLLBACK, se deshace todo, también lo de la de adentro.

SELECT (SELECT COUNT(*) FROM Cliente) AS Clientes_Antes,
       (SELECT stock FROM Producto WHERE Id_producto = 3) AS Stock_P3_Antes;

BEGIN TRANSACTION;   -- transacción de afuera
    INSERT INTO Cliente (Nombre, Apellido, DNI, Num_telefono)
    VALUES ('TestAnidada', 'Prueba', '55667788', '3794333333');

        BEGIN TRANSACTION;   -- transacción de adentro
            UPDATE Producto SET stock = stock - 1 WHERE Id_producto = 3;
            SELECT @@TRANCOUNT AS Transacciones_Abiertas;   -- 2 (las dos están abiertas)
        COMMIT TRANSACTION;   -- cierra la de adentro, pero todavía no guarda nada

    SELECT @@TRANCOUNT AS Transacciones_Abiertas;       -- 1 (queda la de afuera)
ROLLBACK TRANSACTION;   -- la de afuera deshace TODO

SELECT (SELECT COUNT(*) FROM Cliente) AS Clientes_Despues,
       (SELECT stock FROM Producto WHERE Id_producto = 3) AS Stock_P3_Despues,
       @@TRANCOUNT AS Transacciones_Abiertas;
-- Clientes y stock deben ser iguales que en antes
GO


-- ESTAS PRUEBAS SOLO SON POR FALLA CON EL ALMACENADO



-- prueba 4: stock insuficiente -> el error revierte todo (nada cambia)

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


-- prueba 5: falla A MITAD del proceso (metodo de pago inexistente).

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
-- Los tres counts deben ser iguales a los de antes
GO

-- prueba 6: cantidad invalida (0)

BEGIN TRY
    EXEC sp_RegistrarVentaCompleta
        @Id_cliente = 1, @Id_Empleado = 1, @Id_tipo_factura = 1, @Id_metodo = 1,
        @ImporteTotal = 0, @Id_producto = 1, @Cantidad = 0;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS Error, ERROR_MESSAGE() AS Mensaje;
END CATCH;
GO

/*
CONCLUSIONES
1. Prueba 1: cuando todos los pasos salen bien, el COMMIT guarda la venta, el
detalle, el pago y el descuento de stock juntos
2. Prueba 2: al fallar un paso a mitad del proceso, el ROLLBACK deshizo todo.
Los números quedaron igual que antes: no hay ventas a medias
3. Prueba 3: en transacciones anidadas, el COMMIT de la de adentro no guarda
nada por sí solo; el ROLLBACK de la de afuera deshizo también lo de adentro.
4. Pruebas4, 5 y 6: el procedimiento también deshace todo ante stock
insuficiente, método de pago inexistente o cantidad inválida
5. Gracias a esto los datos siempre quedan ordenados: nunca hay una factura
sin pago ni stock descontado sin venta.