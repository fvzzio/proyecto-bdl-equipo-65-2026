create database proyectoBDD2026

use proyectoBDD2026;

CREATE TABLE Puesto_Laboral
(
  Id_puesto INT NOT NULL identity,
  Descripcion VARCHAR(50) NOT NULL,
  constraint pk_puesto_laboral PRIMARY KEY (Id_puesto),
  constraint uq_puesto_descripcion UNIQUE (Descripcion)
);

CREATE TABLE Empleado
(
  Id_Empleado INT NOT NULL identity,
  DNI INT NOT NULL,
  Nombre VARCHAR(50) NOT NULL,
  Apellido VARCHAR(50) NOT NULL,
  Num_telefono VARCHAR(15) NOT NULL,
  Id_puesto INT NOT NULL,
  constraint pk_empleado PRIMARY KEY (Id_Empleado),
  constraint uq_empleado_dni UNIQUE (DNI),
  constraint fk_puesto_laboral FOREIGN KEY (Id_puesto) REFERENCES Puesto_Laboral(Id_puesto)
);

CREATE TABLE Cliente
(
  Id_cliente INT NOT NULL identity,
  DNI INT NOT NULL,
  Nombre VARCHAR(50) NOT NULL,
  Apellido VARCHAR(50) NOT NULL,
  Num_telefono VARCHAR(15) NOT NULL,
  constraint pk_cliente PRIMARY KEY (Id_cliente),
  constraint uq_cliente_dni UNIQUE (DNI),
);

CREATE TABLE Tipo_producto
(
  Id_tipo_producto INT NOT NULL identity,
  Nombre_tipo VARCHAR(50) NOT NULL,
  constraint pk_tipo_producto PRIMARY KEY (Id_tipo_producto),
  constraint uq_tipo_producto_nombre UNIQUE (Nombre_tipo)
);

CREATE TABLE Producto
(
  Id_producto INT NOT NULL identity,
  Descripcion VARCHAR(100) NOT NULL,
  Precio_venta DECIMAL(10,2) NOT NULL,
  stock INT NOT NULL,
  Id_tipo_producto INT NOT NULL,
  constraint pk_producto PRIMARY KEY (Id_producto),
  constraint uq_producto_descripcion UNIQUE (Descripcion),
  constraint fk_tipo_producto FOREIGN KEY (Id_tipo_producto) REFERENCES Tipo_producto(Id_tipo_producto)
);

CREATE TABLE Proveedor
(
  Id_Proveedor INT NOT NULL identity,
  CUIT CHAR(11) NOT NULL,
  Direccion VARCHAR(100) NOT NULL,
  Num_telefono VARCHAR(15) NOT NULL,
  Id_producto INT NOT NULL,
  constraint pk_proveedor PRIMARY KEY (Id_Proveedor),
  constraint uq_proveedor_cuit UNIQUE (CUIT),
  constraint fk_producto FOREIGN KEY (Id_producto) REFERENCES Producto(Id_producto)
);

CREATE TABLE Metodo_pago
(
  Id_metodo INT NOT NULL identity,
  Descripcion VARCHAR(50) NOT NULL,
  constraint pk_metodo_pago PRIMARY KEY (Id_metodo),
  constraint uq_metodo_pago_descripcion UNIQUE (Descripcion)
);

CREATE TABLE Tipo_factura
(
  Id_tipo_factura INT NOT NULL identity,
  Descripcion VARCHAR(50) NOT NULL,
  constraint pk_tipo_factura PRIMARY KEY (Id_tipo_factura),
  constraint uq_tipo_factura_descripcion UNIQUE (Descripcion)
);

CREATE TABLE Venta_Factura
(
  Id_compra INT NOT NULL identity,
  Fecha_hora DATETIME NOT NULL
  Id_cliente INT NOT NULL,
  Id_Empleado INT NOT NULL,
  Id_tipo_factura INT NOT NULL,
  constraint pk_venta_factura PRIMARY KEY (Id_compra),
  constraint fk_cliente FOREIGN KEY (Id_cliente) REFERENCES Cliente(Id_cliente)
  constraint fk_empleado FOREIGN KEY (Id_Empleado) REFERENCES Empleado(Id_Empleado)
  constraint fk_tipo_factura FOREIGN KEY (Id_tipo_factura) REFERENCES Tipo_factura(Id_tipo_factura)
);

CREATE TABLE pago
(
  importeTotal DECIMAL(10,2) NOT NULL,
  Id_metodo INT NOT NULL,
  Id_compra INT NOT NULL,
  constraint pk_pago PRIMARY KEY (Id_metodo, Id_compra),
  constraint fk_metodo_pago FOREIGN KEY (Id_metodo) REFERENCES Metodo_pago(Id_metodo)
  constraint fk_venta_factura FOREIGN KEY (Id_compra) REFERENCES Venta_Factura(Id_compra)
);

CREATE TABLE detalle_compra
(
  cantidad INT NOT NULL,
  Id_producto INT NOT NULL,
  Id_compra INT NOT NULL,
  constraint pk_detalle_compra PRIMARY KEY (Id_producto, Id_compra),
  constraint fk_detalle_producto FOREIGN KEY (Id_producto) REFERENCES Producto(Id_producto)
  constraint fk_detalle_venta_factura FOREIGN KEY (Id_compra) REFERENCES Venta_Factura(Id_compra)
);
