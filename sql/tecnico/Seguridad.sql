USE proyectoBDD2026;
GO

-- 1. Crear Roles (limpia si existían antes)
DROP ROLE IF EXISTS Rol_Vendedor;
GO
CREATE ROLE Rol_Vendedor;
GO

DROP ROLE IF EXISTS Rol_Auditor;
GO
CREATE ROLE Rol_Auditor;
GO

-- 2. Permisos para Rol_Vendedor
GRANT SELECT ON Producto TO Rol_Vendedor;
GRANT SELECT ON Metodo_pago TO Rol_Vendedor;
GRANT SELECT ON Tipo_factura TO Rol_Vendedor;
GRANT SELECT ON Cliente TO Rol_Vendedor;
GRANT EXECUTE ON sp_RegistrarVentaCompleta TO Rol_Vendedor;
GO

-- 3. Permisos para Rol_Auditor
GRANT SELECT ON Auditoria_Precios TO Rol_Auditor;
GRANT SELECT ON Venta_Factura TO Rol_Auditor;
GRANT SELECT ON detalle_compra TO Rol_Auditor;
GRANT SELECT ON pago TO Rol_Auditor;
GO

-- 4. Restricciones para Rol_Vendedor
DENY DELETE ON Venta_Factura TO Rol_Vendedor;
DENY UPDATE ON Venta_Factura TO Rol_Vendedor;
DENY INSERT, UPDATE, DELETE ON Auditoria_Precios TO Rol_Vendedor;
GO
