-- 1. Obtener el número de cliente, la compañía, y número de orden de todos los clientes que tengan
-- órdenes. Ordenar el resultado por número de cliente.

SELECT customer.customer_num, company, order_num 
FROM customer JOIN orders 
ON customer.customer_num = orders.customer_num
ORDER BY customer_num;


-- 2. Listar los ítems de la orden número 1004, incluyendo una descripción de cada uno. El listado debe
-- contener: Número de orden (order_num), Número de Item (item_num), Descripción del producto
-- (product_types.description), Código del fabricante (manu_code), Cantidad (quantity), Precio total
-- (unit_price*quantity).


--Pregunta : Porque pone corchetes en description (Automaticamente) -> Es algo especifico de SQL server para indicar que es un atributo
-- No es necesario tener los corchetes [] (Medio al pedo, a parte no es un estandar de SQL)

SELECT order_num, item_num, [description], manu_code, quantity, (unit_price * quantity) total_price 
FROM items JOIN product_types
ON items.stock_num = product_types.stock_num
WHERE order_num = 1004;


-- 3. Listar los items de la orden número 1004, incluyendo una descripción de cada uno. El listado debe
-- contener: Número de orden (order_num), Número de Item (item_num), Descripción del Producto
-- (product_types.description), Código del fabricante (manu_code), Cantidad (quantity), precio total
-- (unit_price*quantity) y Nombre del fabricante (manu_name).


SELECT order_num, item_num, [description], items.manu_code, quantity, (unit_price * quantity) total_price , manu_name
FROM items 
JOIN product_types ON items.stock_num = product_types.stock_num
JOIN manufact ON items.manu_code = manufact.manu_code
WHERE order_num = 1004;


-- 4. Se desea listar todos los clientes que posean órdenes de compra. Los datos a listar son los
-- siguientes: número de orden, número de cliente, nombre, apellido y compañía.

SELECT order_num, customer.customer_num, fname, lname, company
FROM customer JOIN orders 
ON customer.customer_num = orders.customer_num;


-- 5. Se desea listar todos los clientes que posean órdenes de compra. Los datos a listar son los
-- siguientes: número de cliente, nombre, apellido y compañía. Se requiere sólo una fila por cliente.

SELECT DISTINCT customer.customer_num, fname, lname, company
FROM customer JOIN orders 
ON customer.customer_num = orders.customer_num
ORDER BY customer.customer_num;

-- 6. Se requiere listar para armar una nueva lista de precios los siguientes datos: nombre del fabricante
-- (manu_name), número de stock (stock_num), descripción
-- (product_types.description), unidad (units.unit), precio unitario (unit_price) y Precio Junio (precio
-- unitario + 20%).


SELECT manu_name, products.stock_num, [description], unit, unit_price, (unit_price * 1.2) june_price
FROM manufact 
JOIN products ON manufact.manu_code = products.manu_code
JOIN product_types ON products.stock_num = product_types.stock_num
JOIN units ON units.unit_code = products.unit_code;




-- 7. Se requiere un listado de los items de la orden de pedido Nro. 1004 con los siguientes datos:
-- Número de item (item_num), descripción de cada producto (product_types.description), cantidad (quantity) y precio total (unit_price*quantity).


SELECT item_num,  description, quantity, (unit_price * quantity) total_price
FROM items JOIN product_types 
ON items.stock_num = product_types.stock_num
WHERE order_num = 1004;


-- 8. Informar el nombre del fabricante (manu_name) y el tiempo de envío (lead_time) de los ítems de
-- las Órdenes del cliente 104.

SELECT manu_name, lead_time
FROM manufact 
    JOIN items ON manufact.manu_code = items.manu_code
    JOIN orders ON orders.order_num = items.order_num
WHERE customer_num = 104 ;



-- 9. Se requiere un listado de las todas las órdenes de pedido con los siguientes datos: Número de
-- orden (order_num), fecha de la orden (order_date), número de ítem (item_num), descripción de
-- cada producto (description), cantidad (quantity) y precio total (unit_price*quantity).


SELECT orders.order_num, order_date, item_num, description, quantity, (unit_price * quantity) total_price
FROM orders 
    JOIN items ON (orders.order_num = items.order_num)
    JOIN product_types ON (product_types.stock_num = items.stock_num);



-- 10. Obtener un listado con la siguiente información: Apellido (lname) y Nombre (fname) del Cliente
-- separado por coma, Número de teléfono (phone) en formato (999) 999-9999. Ordenado por
-- apellido y nombre.


SELECT (lname+', '+ fname) nombre_y_apellido , ('(' + SUBSTRING(phone, 1, 3) + ')' + SUBSTRING(phone, 4, 8) ) telefono
FROM customer
ORDER BY nombre_y_apellido;


-- 11. Obtener la fecha de embarque (ship_date), Apellido (lname) y Nombre (fname) del Cliente
-- separado por coma y la cantidad de órdenes del cliente. Para aquellos clientes que viven en el
-- estado con descripción (sname) “California” y el código postal está entre 94000 y 94100 inclusive.
-- Ordenado por fecha de embarque y, Apellido y nombre.


SELECT ship_date,  (lname+', '+ fname) apellido_y_nombre , COUNT(order_num) cant_ordenes
FROM orders
    JOIN customer ON (customer.customer_num = orders.customer_num)
    JOIN state ON (state.[state] = customer.[state])
WHERE 
    sname LIKE'California' AND 
    zipcode BETWEEN 94000 AND 94100
GROUP BY lname, fname, ship_date
ORDER BY ship_date, apellido_y_nombre;




-- 12. Obtener por cada fabricante (manu_name) y producto (description), la cantidad vendida y el
-- Monto Total vendido (unit_price * quantity). Sólo se deberán mostrar los ítems de los fabricantes
-- ANZ, HRO, HSK y SMT, para las órdenes correspondientes a los meses de mayo y junio del 2015.
-- Ordenar el resultado por el monto total vendido de mayor a menor.



SELECT manu_name, description, quantity, (items.unit_price * quantity) total_price
FROM manufact
    JOIN items ON (items.manu_code = manufact.manu_code)
    JOIN product_types ON (product_types.stock_num = items.stock_num)
    JOIN orders ON (orders.order_num = items.order_num)
WHERE 
    items.manu_code = 'ANZ' OR 
    items.manu_code = 'HRO' OR 
    items.manu_code = 'HSK' OR
    items.manu_code = 'SMT' AND

    YEAR(order_date) = 2015 AND
    MONTH(order_date) BETWEEN  5 AND 6
ORDER BY total_price;



-- 13. Emitir un reporte con la cantidad de unidades vendidas y el importe total por mes de productos,
-- ordenado por importe total en forma descendente.
-- Formato: Año/Mes  Cantidad   Monto_Total

SELECT YEAR(order_date) Año, MONTH(order_date) Mes, SUM(quantity) Cantidad, SUM(unit_price * quantity) Monto_Total
FROM items
    JOIN orders ON (orders.order_num = items.order_num)
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY Monto_Total DESC;
