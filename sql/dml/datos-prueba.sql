
USE proyectoBDD2026;

INSERT INTO Puesto_Laboral (Descripcion) VALUES
('Gerente'),
('Cajero'),

INSERT INTO Tipo_producto (Nombre_tipo) VALUES
('pastas')
('carnes')
('lacteos')
('limpieza')
('aseo personal')
('Galletas') 
('Mascotas')
('Electrodomesticos')
('Panaderia')
('bebidas')

INSERT INTO Metodo_pago (Descripcion) VALUES
('Efectivo'),
('Transferencia'),
('Tarjeta'),

INSERT INTO Tipo_factura (Descripcion) VALUES
('Factura A'),
('Factura B'),

INSERT INTO Cliente (DNI, Nombre, Apellido, Num_telefono) VALUES
(30123456, 'Lucas',    'Fernandez', '3794123456'),
(32456789, 'Camila',   'Gomez',     '3794234567'),
(28987654, 'Martin',   'Acosta',    '3794345678'),
(35111222, 'Sofia',    'Benitez',   '3794456789'),
(27333444, 'Diego',    'Romero',    '3794567890'),
(38555666, 'Valentina','Ledesma',   '3794678901'),
(31777888, 'Nicolas',  'Vera',      '3794789012'),
(40222333, 'Julieta',  'Ortiz',     '3794890123'),
(29444555, 'Federico', 'Medina',    '3794901234'),
(36666777, 'Agustina', 'Duarte',    '3794012345');

/* 2) Empleado y Producto */

INSERT INTO Empleado (DNI, Nombre, Apellido, Num_telefono, Id_puesto) VALUES
(25111111, 'Roberto', 'Silva',     '3794111111', 1),
(26222222, 'Marcela', 'Lopez',     '3794222222', 2),
(33333333, 'Carolina','Pereyra',   '3794333333', 3),
(34444444, 'Javier',  'Gutierrez', '3794444444', 4),
(37555555, 'Lautaro', 'Cabrera',   '3794555555', 5),
(39666666, 'Mariana', 'Sosa',      '3794666666', 6),
(24777777, 'Gabriela','Nunez',     '3794777777', 7),
(41888888, 'Tomas',   'Ruiz',      '3794888888', 8),
(23999999, 'Hector',  'Franco',    '3794999999', 9),
(22000000, 'Elena',   'Maidana',   '3794000000', 10);

INSERT INTO Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) VALUES
('Gaseosa cola 2.25L',            2800.00, 120, 1),
('Leche entera 1L',               1500.00,  80, 2),
('Pan lactal 500g',               2300.00,  60, 3),
('Detergente 750ml',              2100.00,  45, 4),
('Arroz largo fino 1kg',          1900.00, 100, 5),
('Papas fritas 150g',             2600.00,  70, 6),
('Jamon cocido 200g',             3500.00,  30, 7),
('Tomate perita 1kg',             2200.00,  50, 8),
('Shampoo 400ml',                 4200.00,  35, 9),
('Hamburguesas congeladas x4',    5200.00,  40, 10);

/* 3) Proveedor y Venta_Factura */

INSERT INTO Proveedor (CUIT, Direccion, Num_telefono, Id_producto) VALUES
('30711111119', 'Av. Costanera 1200, Corrientes',     '3794100001', 1),
('30722222228', 'Ruta 12 Km 5, Corrientes',           '3794100002', 2),
('30733333337', 'Calle Salta 450, Corrientes',        '3794100003', 3),
('30744444446', 'Av. Armenia 800, Corrientes',        '3794100004', 4),
('30755555555', 'Calle Junin 322, Resistencia',       '3624100005', 5),
('30766666664', 'Av. Libertad 1500, Corrientes',      '3794100006', 6),
('30777777773', 'Calle Mendoza 215, Corrientes',      '3794100007', 7),
('30788888882', 'Mercado Central, Corrientes',        '3794100008', 8),
('30799999991', 'Av. Maipu 640, Corrientes',          '3794100009', 9),
('30700000000', 'Ruta 11 Km 8, Resistencia',          '3624100010', 10);

INSERT INTO Venta_Factura (Fecha_hora, Id_cliente, Id_Empleado, Id_tipo_factura) VALUES
('20261001 09:15:00',  1, 3, 2),
('20261002 10:30:00',  2, 3, 2),
('20261005 11:45:00',  3, 4, 2),
('20261007 13:20:00',  4, 3, 1),
('20261009 16:05:00',  5, 4, 1),
('20261012 17:40:00',  6, 3, 2),
('20261015 18:10:00',  7, 4, 6),
('20261019 09:50:00',  8, 3, 2),
('20261022 12:25:00',  9, 4, 2),
('20261026 19:00:00', 10, 3, 2);

/* 4) detalle_compra y pago */

INSERT INTO detalle_compra (cantidad, Id_producto, Id_compra) VALUES
(2, 1, 1), (1, 5, 1),     -- Venta 1  = 7500
(3, 2, 2), (1, 3, 2),     -- Venta 2  = 6800
(1, 4, 3), (1, 9, 3),     -- Venta 3  = 6300
(2, 6, 4), (1, 1, 4),     -- Venta 4  = 8000
(2, 7, 5), (2, 3, 5),     -- Venta 5  = 11600
(2, 8, 6), (2, 5, 6),     -- Venta 6  = 8200
(1, 10, 7),(2, 2, 7),     -- Venta 7  = 8200
(2, 9, 8),                -- Venta 8  = 8400
(3, 5, 9), (1, 6, 9),     -- Venta 9  = 8300
(4, 1, 10),(2, 4, 10);    -- Venta 10 = 15400

INSERT INTO pago (importeTotal, Id_metodo, Id_compra) VALUES
( 7500.00, 1, 1),
( 6800.00, 2, 2),
( 6300.00, 2, 3),
( 8000.00, 1, 4),
(11600.00, 1, 5),
( 8200.00, 1, 6),
( 8200.00, 1, 7),
( 8400.00, 2, 8),
( 8300.00, 1, 9),
( 5400.00, 1, 10),
(10000.00, 2, 10);

