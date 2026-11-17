
--SEGURIDAD

USE proyectoBDD2026;
GO


-- 1. CREACIÓN DE ROLES PERSONALIZADOS
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Rol_Vendedor' AND type = 'R')
    CREATE ROLE Rol_Vendedor;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Rol_Auditor' AND type = 'R')
    CREATE ROLE Rol_Auditor;
GO


-- 2. CONFIGURACIÓN DE PERMISOS (GRANT Y DENY)


-- Permisos del Vendedor (diaria de caja)
GRANT SELECT ON Producto TO Rol_Vendedor;
GRANT SELECT ON Metodo_pago TO Rol_Vendedor;
GRANT SELECT ON Tipo_factura TO Rol_Vendedor;
GRANT SELECT ON Cliente TO Rol_Vendedor;
GRANT EXECUTE ON sp_RegistrarVentaCompleta TO Rol_Vendedor;
GRANT EXECUTE ON sp_InsertarCliente TO Rol_Vendedor;

-- Permisos del Auditor (fiscalización, historial)
GRANT SELECT ON Auditoria_Precios TO Rol_Auditor;
GRANT SELECT ON Venta_Factura TO Rol_Auditor;
GRANT SELECT ON detalle_compra TO Rol_Auditor;
GRANT SELECT ON pago TO Rol_Auditor;

-- Restricciones estrictas de seguridad 
DENY DELETE ON Venta_Factura TO Rol_Vendedor;
DENY UPDATE ON Venta_Factura TO Rol_Vendedor;
DENY INSERT, UPDATE, DELETE ON Auditoria_Precios TO Rol_Vendedor;
GO


-- 3. CREACIÓN DE LOGINS Y USUARIOS DE PRUEBA

--crear login y usuario Administrador
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'AdminSuper')
    CREATE LOGIN AdminSuper WITH PASSWORD = '1234';
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'UserAdmin')
    CREATE USER UserAdmin FOR LOGIN AdminSuper;
GO
ALTER ROLE db_owner ADD MEMBER UserAdmin; 
GO

-- B. Crear Login y Usuario Vendedor
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'CajeroJuan')
    CREATE LOGIN CajeroJuan WITH PASSWORD = '12345';
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'UserVendedor')
    CREATE USER UserVendedor FOR LOGIN CajeroJuan;
GO
ALTER ROLE Rol_Vendedor ADD MEMBER UserVendedor;
GO

-- C. Crear Login y Usuario Auditor
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'AuditorAna')
    CREATE LOGIN AuditorAna WITH PASSWORD = '123456';
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'UserAuditor')
    CREATE USER UserAuditor FOR LOGIN AuditorAna;
GO
ALTER ROLE Rol_Auditor ADD MEMBER UserAuditor;
GO

-- D. Crear Login y Usuario EXTERNO 
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'UsuarioExterno')
    CREATE LOGIN UsuarioExterno WITH PASSWORD = 'externo';
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'UserExterno')
    CREATE USER UserExterno FOR LOGIN UsuarioExterno;
GO

GO



--4. SCRIPTS DE PRUEBA Y VERIFICACIÓN DE SEGURIDAD

--1: Vendedor intentando insertar directo a la tabla Cliente 
EXECUTE AS USER = 'UserVendedor';
BEGIN TRY
    INSERT INTO Cliente (Nombre, Apellido, DNI, Num_telefono) 
    VALUES ('hacker', 'sinaura', '00000000', '0000000');
    PRINT '1. El vendedor pudo insertar directo.';
END TRY
BEGIN CATCH
    PRINT '1. El INSERT directo fue bloqueado'
END CATCH;
REVERT;
GO

--2: Vendedor usando el procedimiento almacenado (APROBAR)
EXECUTE AS USER = 'UserVendedor';
BEGIN TRY
    EXEC sp_InsertarCliente @Nombre = 'ClientePermitido', @Apellido = 'Prueba', @DNI = '11223344', @Telefono = '3794000000';
    PRINT '2. el vendedor pudo registrar al cliente a través del procedimiento autorizado';
END TRY
BEGIN CATCH
    PRINT '2. ERRO '
END CATCH;
REVERT;
GO

--3: Usuario Auditor consultando la tabla de auditoría (APROBAR)
EXECUTE AS USER = 'UserAuditor';
BEGIN TRY
    SELECT TOP 1 * FROM Auditoria_Precios;
    PRINT '3. el auditor tiene permiso de lectura sobre la auditoría';
END TRY
BEGIN CATCH
    PRINT '3. ERROR '
END CATCH;
REVERT;
GO

-- PRUEBA 4: Usuario Externo (sin rol) intentando leer la auditoría (DEBE FALLAR)
EXECUTE AS USER = 'UserExterno';
BEGIN TRY
    SELECT * FROM Auditoria_Precios;
    PRINT '4. el usuario externo pudo leer datos confidenciales';
END TRY
BEGIN CATCH
    PRINT '4. el acceso fue denegado al usuario sin rol ';
END CATCH;
REVERT;
GO