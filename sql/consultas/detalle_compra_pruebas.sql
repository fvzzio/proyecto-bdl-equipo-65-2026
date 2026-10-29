USE proyectoBDD2026;
GO

-- 1. Tipos de Factura
INSERT INTO Tipo_factura (Descripcion) VALUES ('Factura A'); 
INSERT INTO Tipo_factura (Descripcion) VALUES ('Factura B'); 
INSERT INTO Tipo_factura (Descripcion) VALUES ('Factura C'); 
GO

-- 2. Ventas (Cabecera)
INSERT INTO Venta_Factura (Fecha_hora, Id_cliente, Id_Empleado, Id_tipo_factura) 
VALUES ('2026-10-16', 1, 1, 1); 

INSERT INTO Venta_Factura (Fecha_hora, Id_cliente, Id_Empleado, Id_tipo_factura) 
VALUES ('2026-10-16', 2, 2, 2); 

INSERT INTO Venta_Factura (Fecha_hora, Id_cliente, Id_Empleado, Id_tipo_factura) 
VALUES ('2026-10-16', 3, 3, 1); 
GO

-- 3. Detalle de Compras (Productos y Cantidades)
INSERT INTO detalle_compra (cantidad, Id_producto, Id_compra) VALUES (2, 1, 1); 
INSERT INTO detalle_compra (cantidad, Id_producto, Id_compra) VALUES (1, 3, 1); 

INSERT INTO detalle_compra (cantidad, Id_producto, Id_compra) VALUES (1, 2, 2); 
INSERT INTO detalle_compra (cantidad, Id_producto, Id_compra) VALUES (3, 6, 2); 

INSERT INTO detalle_compra (cantidad, Id_producto, Id_compra) VALUES (2, 5, 3); 
INSERT INTO detalle_compra (cantidad, Id_producto, Id_compra) VALUES (1, 11, 3);
GO

-- 4. Pagos
INSERT INTO pago (importeTotal, Id_metodo, Id_compra) VALUES (6300, 1, 1); 
INSERT INTO pago (importeTotal, Id_metodo, Id_compra) VALUES (14500, 3, 2);  
INSERT INTO pago (importeTotal, Id_metodo, Id_compra) VALUES (52000, 2, 3); 
GO
