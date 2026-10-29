use proyectoBDD2026;
---------------------------------------Productos---------------------------
alter table Producto
alter column descripcion varchar(100)

alter table Tipo_producto
alter column nombre_tipo varchar(100)

--------------------------------cliente-----------------------------------
alter table Cliente
alter column DNI varchar(11)
alter table Cliente
alter column Nombre varchar(50)
alter table Cliente
alter column Apellido varchar(50)
alter table Cliente
alter column Num_telefono varchar(25)
-------------------------------------------Empleados-----------------------
Alter table Empleado
alter column DNI varchar(11)
Alter table Empleado
alter column Nombre varchar(25)
Alter table Empleado
alter column Apellido varchar(25)
Alter table Empleado
alter column Num_telefono varchar(25)
Alter table Puesto_laboral
alter column Descripcion varchar(25)

----------------------------------------------------Metodo Pago-----------------------------------------------------------
alter table Metodo_Pago
alter column Descripcion varchar (50)

---------------------------------------------------Proveedor--------------------------------------------------------------
alter table Proveedor
alter column cuit varchar(25)
alter table Proveedor
alter column Direccion varchar (50)
alter table Proveedor
alter column num_telefono varchar(30)

---------------------------------------------------------- Ingresos ------------------------------------------------------

insert into Cliente (DNI, Nombre, Apellido, Num_telefono) values (33441678, 'Jose', 'Hernandez', 154678954)
insert into Cliente (DNI, Nombre, Apellido, Num_telefono) values (33476189, 'Juan', 'Gutierrez', 154966884)
insert into Cliente (DNI, Nombre, Apellido, Num_telefono) values (42414698, 'Luis', 'Gomez', 154699054)
insert into Cliente (DNI, Nombre, Apellido, Num_telefono) values (31840928, 'Martha', 'Lopez', 154178099)
insert into Cliente (DNI, Nombre, Apellido, Num_telefono) values (45879201, 'Susana', 'Hernandez', 154428562)

insert into Tipo_producto (Nombre_tipo) values ('pastas')
insert into Tipo_producto (Nombre_tipo) values ('carnes')
insert into Tipo_producto (Nombre_tipo) values ('lacteos')
insert into Tipo_producto (Nombre_tipo) values ('limpieza')
insert into Tipo_producto (Nombre_tipo) values ('aseo personal')
insert into Tipo_producto (Nombre_tipo) values ('Galletas') 
insert into Tipo_producto (Nombre_tipo) values ('Mascotas')
insert into Tipo_producto (Nombre_tipo) values ('Electrodomesticos')
insert into Tipo_producto (Nombre_tipo) values ('Panaderia')
insert into Tipo_producto (Nombre_tipo) values ('bebidas')

insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Fideos tallarin', 2000, 10, 2)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('kilo de carne', 10000, 20, 3)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Leche en sachet', 2300, 25, 4)

insert into Puesto_Laboral (Descripcion) values ('Cajero') 

insert into Empleado(DNI, Nombre, Apellido, Num_telefono,Id_puesto) values (22817829, 'Jorge', 'Sanchez', 3624557788, 1)
insert into Empleado(DNI, Nombre, Apellido, Num_telefono,Id_puesto) values (50313214, 'Soledad', 'Rodriguez', 3624152819, 1)
insert into Empleado(DNI, Nombre, Apellido, Num_telefono,Id_puesto) values (38532817, 'Rosario', 'Avalos', 3624248662, 1)
insert into Empleado(DNI, Nombre, Apellido, Num_telefono,Id_puesto) values (44039513, 'Gonzalo', 'Duarte', 3624360579, 1)
insert into Empleado(DNI, Nombre, Apellido, Num_telefono,Id_puesto) values (42323451, 'Marcos', 'Roldan', 3624154439, 1)

insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Fideos Codito', 2000, 20, 2)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Jabon de tocador', 2500, 20, 6)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Kilo de Pan', 1500, 20, 10)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Tira de Asado', 13000, 15, 3)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Lavandina Ayudin 4lt', 3900, 20, 5)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Lavandina Heroe 1lt', 1150, 20, 5)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Leche en Caja', 2490, 25, 4)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Licuadora', 47000, 10, 9)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Galletitas Saladas', 1500, 25, 7)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Surtidos Bagley', 5000, 20, 7)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Alimento Perros 20kg', 32000, 25, 8)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Jabon Blanco', 1000, 20, 6)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Desodorante Rexona', 6000, 20, 6)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Desodorante Dove', 4300, 20, 6)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Alimento Gatos Wiskas 10kg', 56900, 15, 8)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Galletitas Diversion', 3900, 15, 7)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Lavarropas comfort ', 240700, 10, 9)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Media docena Fact', 4300, 10, 10)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Desodorante pisos Poett', 4000, 20, 5)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Whisky Jack Daniells', 51000, 10, 11)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Vino Toro 1 lt', 4987, 15, 11)
insert into Producto (Descripcion, Precio_venta, stock, Id_tipo_producto) values ('Coca cola 2.25 lts', 4500, 15, 11)

insert into Metodo_pago (Descripcion) values ('Efectivo')
insert into Metodo_pago (Descripcion) values ('Transferencia')
insert into Metodo_pago (Descripcion) values ('Tarjeta')

insert into Proveedor(CUIT, Direccion, Num_telefono, Id_producto) values (20445679871, 'Lopez y planes 241', 3625441211, 15)
insert into Proveedor(CUIT, Direccion, Num_telefono, Id_producto) values (20458719237, 'Alberdi 2003', 3624998123, 17)
insert into Proveedor(CUIT, Direccion, Num_telefono, Id_producto) values (20239917235, 'San Martin y 9 de julio', 3624778123, 11)
insert into Proveedor(CUIT, Direccion, Num_telefono, Id_producto) values (20389249049, 'Paraguay y Sarmiento', 3625718892, 12)

