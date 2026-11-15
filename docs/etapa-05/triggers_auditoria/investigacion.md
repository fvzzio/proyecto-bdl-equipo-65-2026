# Triggers de auditoria

## Concepto
Un trigger es codigo que SQL Server ejecuta automaticamente ante un `INSERT`, `UPDATE` o `DELETE`, Dentro del trigger se dispone de dos tablas virtuales: `DELETED` (valores anteriores) `INSERTED` (valores nuevos) Se usan para auditoria, trazabilidad y control

## Que implementamos
Tabla `Auditoria_Precios` (producto, precio anterior, precio nuevo, fecha y hora, usuario)
Trigger `trg_AuditarCambioPrecioProducto` sobre `Producto`, `AFTER UPDATE` con `IF UPDATE(Precio_venta)` detecta si se toco el precio y guarda precio viejo (`DELETED`), precio nuevo (`INSERTED`), `GETDATE()` y `SYSTEM_USER`, Solo registra cuando el valor realmente cambia

