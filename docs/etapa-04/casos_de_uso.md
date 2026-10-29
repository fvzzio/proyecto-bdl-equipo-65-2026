# Casos de uso de las consultas SQL

En este documento explicamos como se aplican en la vida real y en el funcionamiento cotidiano del sistema las tres consultas SQL que desarrollamos sobre la base de datos `proyectoBDD2026`.

## Caso de uso 1: Emision de ticket o factura en caja

Este caso de uso se da cuando un cliente termina de elegir sus productos y pasa por la caja a pagar.

El cajero pasa los productos por el sistema y cobra. En ese momento, el sistema ejecuta la consulta del **Comprobante de venta**. Al pasarle el ID de la compra que se acaba de registrar, la consulta devuelve todos los renglones con los productos, las cantidades, el cajero que atendio, el metodo de pago seleccionado y el total general que calcula la funcion `SUM() OVER`. Con esa informacion el sistema manda a imprimir el ticket impreso para el cliente.

## Caso de uso 2: Evaluacion de vendedores y pago de comisiones

Este caso de uso lo ejecuta el administrador o gerente de ventas a fin de mes o de ano.

Para evaluar el desempeno del personal o calcular bonos por productividad, se corre la consulta del **Informe de ventas por vendedor**. El usuario ingresa la fecha de inicio y de fin del mes, y el script devuelve el listado de todos los empleados ordenados por la cantidad de dinero que recaudaron. Esto permite ver rapidamente quienes cumplieron los objetivos de venta.

## Caso de uso 3: Control de stock y rotacion de productos

Este caso de uso lo utiliza el encargado de compras o de deposito cuando tiene que hacer nuevos pedidos a los proveedores.

Antes de gastar presupuesto en mercaderia, el encargado revisa el **Informe por categoria** y la **Consulta avanzada con HAVING**. Con estos reportes puede identificar cuales son los productos que realmente tienen rotacion (unidades vendidas mayor o igual a 1) y cuales categorias generan la mayor parte de los ingresos, evitando comprar de mas en productos que no se venden.