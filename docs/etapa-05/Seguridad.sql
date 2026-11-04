
USE proyectoBDD2026;
GO

CREATE ROLE Rol_Vendedor;
CREATE ROLE Rol_Auditor;
GO


GRANT SELECT ON Producto TO Rol_Vendedor;
GRANT SELECT ON Metodo_pago TO Rol_Vendedor;
GRANT SELECT ON Tipo_factura TO Rol_Vendedor;
GRANT SELECT ON Cliente TO Rol_Vendedor;
GRANT EXECUTE ON sp_RegistrarVentaCompleta TO Rol_Vendedor;
GO

GRANT SELECT ON Auditoria_Precios TO Rol_Auditor;
GRANT SELECT ON Venta_Factura TO Rol_Auditor;
GRANT SELECT ON detalle_compra TO Rol_Auditor;
GRANT SELECT ON pago TO Rol_Auditor;
GO

DENY DELETE ON Venta_Factura TO Rol_Vendedor;
DENY UPDATE ON Venta_Factura TO Rol_Vendedor;
DENY INSERT, UPDATE, DELETE ON Auditoria_Precios TO Rol_Vendedor;
GO