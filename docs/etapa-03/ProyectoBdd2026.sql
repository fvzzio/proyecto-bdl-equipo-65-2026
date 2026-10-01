create database proyectoBDD2026

use proyectoBDD2026;

CREATE TABLE Puesto_Laboral
(
  Id_puesto INT NOT NULL identity,
  Descripcion VARCHAR NOT NULL,
  constraint pk_puesto_laboral PRIMARY KEY (Id_puesto)
);

CREATE TABLE Empleado
(
  Id_Empleado INT NOT NULL identity,
  DNI INT NOT NULL,
  Nombre VARCHAR NOT NULL,
  Apellido VARCHAR NOT NULL,
  Num_telefono INT NOT NULL,
  Id_puesto INT NOT NULL,
  constraint pk_empleado PRIMARY KEY (Id_Empleado),
  constraint fk_puesto_laboral FOREIGN KEY (Id_puesto) REFERENCES Puesto_Laboral(Id_puesto)
);

CREATE TABLE Cliente
(
  Id_cliente INT NOT NULL identity,
  DNI INT NOT NULL,
  Nombre VARCHAR NOT NULL,
  Apellido VARCHAR NOT NULL,
  Num_telefono INT NOT NULL,
  constraint pk_cliente PRIMARY KEY (Id_cliente)
);

CREATE TABLE Tipo_producto
(
  Id_tipo_producto INT NOT NULL identity,
  Nombre_tipo VARCHAR NOT NULL,
  constraint pk_tipo_producto PRIMARY KEY (Id_tipo_producto)
);

CREATE TABLE Producto
(
  Id_producto INT NOT NULL identity,
  Descripcion VARCHAR NOT NULL,
  Precio_venta INT NOT NULL,
  stock INT NOT NULL,
  Id_tipo_producto INT NOT NULL,
  constraint pk_producto PRIMARY KEY (Id_producto),
  constraint fk_tipo_producto FOREIGN KEY (Id_tipo_producto) REFERENCES Tipo_producto(Id_tipo_producto)
);

CREATE TABLE Proveedor
(
  Id_Proveedor INT NOT NULL identity,
  CUIT INT NOT NULL,
  Direccion VARCHAR NOT NULL,
  Num_telefono INT NOT NULL,
  Id_producto INT NOT NULL,
  constraint pk_proveedor PRIMARY KEY (Id_Proveedor),
  constraint fk_producto FOREIGN KEY (Id_producto) REFERENCES Producto(Id_producto)
);

CREATE TABLE Metodo_pago
(
  Id_metodo INT NOT NULL identity,
  Descripcion VARCHAR NOT NULL,
  constraint pk_metodo_pago PRIMARY KEY (Id_metodo)
);

CREATE TABLE Tipo_factura
(
  Id_tipo_factura INT NOT NULL identity,
  Descripcion VARCHAR NOT NULL,
  constraint pk_tipo_factura PRIMARY KEY (Id_tipo_factura)
);

CREATE TABLE Venta_Factura
(
  Id_compra INT NOT NULL identity,
  Fecha_hora DATE NOT NULL,
  Id_cliente INT NOT NULL,
  Id_Empleado INT NOT NULL,
  Id_tipo_factura INT NOT NULL,
  constraint pk_venta_factura PRIMARY KEY (Id_compra),
  constraint fk_cliente FOREIGN KEY (Id_cliente) REFERENCES Cliente(Id_cliente),
  constraint fk_empleado FOREIGN KEY (Id_Empleado) REFERENCES Empleado(Id_Empleado),
  constraint fk_tipo_factura FOREIGN KEY (Id_tipo_factura) REFERENCES Tipo_factura(Id_tipo_factura)
);

CREATE TABLE pago
(
  importeTotal INT NOT NULL,
  Id_metodo INT NOT NULL,
  Id_compra INT NOT NULL,
  constraint pk_pago PRIMARY KEY (Id_metodo, Id_compra),
  constraint fk_metodo_pago FOREIGN KEY (Id_metodo) REFERENCES Metodo_pago(Id_metodo),
  constraint fk_venta_factura FOREIGN KEY (Id_compra) REFERENCES Venta_Factura(Id_compra)
);

CREATE TABLE detalle_compra
(
  cantidad INT NOT NULL,
  Id_producto INT NOT NULL,
  Id_compra INT NOT NULL,
  PRIMARY KEY (Id_producto, Id_compra),
  FOREIGN KEY (Id_producto) REFERENCES Producto(Id_producto),
  Constraint fk_venta_factura FOREIGN KEY (Id_compra) REFERENCES Venta_Factura(Id_compra)
);
