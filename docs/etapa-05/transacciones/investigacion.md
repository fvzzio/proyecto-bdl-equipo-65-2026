# Transacciones

## Concepto
Una transaccion agrupa varias operaciones para que se ejecuten como una sola unidad ("todo o nada") Cumple las propiedades **ACID**:
**Atomicidad:** se confirma todo o se revierte todo
**Consistencia:** los datos siempre respetan las reglas (claves foraneas, restricciones)
**Aislamiento:** una transaccion no interfiere con otras que corren al mismo tiempo
**Durabilidad:** lo confirmado con `COMMIT` queda guardado

Patron usado: `BEGIN TRY` > `BEGIN TRANSACTION` > `COMMIT`, si hay error el `CATCH` hace `IF @@TRANCOUNT > 0 ROLLBACK` y vuelve a lanzar el error con `THROW`

## Donde esta aplicado
La transaccion esta dentro de `sp_RegistrarVentaCompleta` de modo que nunca quede una factura sin detalle, sin pago o con el stock sin descontar


