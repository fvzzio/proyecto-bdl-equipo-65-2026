# Procedimientos almacenados y funciones

## Concepto
**Procedimiento almacenado:** conjunto precompilado de instrucciones SQL que se ejecuta con `EXEC`. Sirve para operaciones complejas y repetitivas (varios `INSERT`/`UPDATE` coordinados) y permite validar datos y controlar permisos en un solo lugar
**Funcion definida por el usuario (escalar):** logica reutilizable que recibe parametros y devuelve un valor. Se puede usar dentro de un `SELECT` o dentro de otros objetos. No modifica datos

## Que implementamos en el sistema de ventas
`sp_RegistrarVentaCompleta`: recibe cliente, empleado, tipo de factura, metodo de pago, importe, producto y cantidad. Valida la cantidad y el stock, inserta la cabecera en `Venta_Factura`, toma el id generado con `SCOPE_IDENTITY()`, inserta `detalle_compra` y `pago`, y descuenta el stock del producto
`dbo.fn_StockDisponible(@Id_producto)`: devuelve el stock actual; la usa el procedimiento para validar
`dbo.fn_CalcularDescuentoCliente(@Id_cliente)`: devuelve el porcentaje de descuento segun lo gastado por el cliente (>= 4000: 0.10, entre 2000 y 3999: 0.05, menos de 2000: 0.00) Suma `pago.importeTotal` unido con `Venta_Factura`

