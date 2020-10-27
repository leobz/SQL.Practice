-- 1 Obtener un listado de todos los clientes y sus direcciones.

SELECT fname, address1 
FROM customer;

-- 2. Obtener el listado anterior pero sólo los clientes que viven en el estado de California “CA”.

SELECT fname, address1 
FROM customer
WHERE state = 'CA';


-- 3. Listar todas las ciudades (city) de la tabla clientes que pertenecen al estado de “CA”, mostrar sólo una
-- vez cada ciudad.

SELECT DISTINCT city 
FROM customer
WHERE state = 'CA';


-- 4. Ordenar la lista anterior alfabéticamente.
SELECT DISTINCT city 
FROM customer
WHERE state = 'CA'
ORDER BY city;



-- 5. Mostrar la dirección sólo del cliente 103. (customer_num)

SELECT DISTINCT address1 
FROM customer
WHERE customer_num = 103;


-- 6.Mostrar la lista de productos que fabrica el fabricante “ANZ”ordenada por el campo Código de Unidad de Medida. (unit_code)
--VER

SELECT * FROM products, product_types
WHERE manu_code = 'ANZ'
order by unit_code;


-- 7.Listar los códigos de fabricantes que tengan alguna orden de pedido ingresada, ordenados alfabéticamente y no repetidos. 
SELECT DISTINCT manu_code FROM items, orders
ORDER BY manu_code;


-- 8.Escribir una sentencia SELECT que devuelva el número de orden, fecha de orden, número de cliente y
--  fecha de embarque de todas las órdenes que no han sido pagadas (paid_date es nulo), 
--  pero fueron embarcadas (ship_date) durante los primeros seis meses de 2015.

SELECT order_num , order_date, customer_num, ship_date FROM orders
WHERE paid_date IS NULL; AND
ship_date BETWEEN CAST('2015-01-01' AS DATE) AND CAST('2015-07-01' AS DATE);



--  9. Obtener de la tabla cliente (customer) los número declientes y
--  nombres de las compañías, cuyos nombres de compañías contengan la palabra “town”. 

SELECT fname, phone, company FROM customer
WHERE company LIKE '%town%';


-- 10. Obtener el precio máximo, mínimo y precio promedio pagado 
-- (ship_charge) por todos los embarques. Se pide obtener la información de la tabla ordenes (orders).  


SELECT MAX(ship_charge) FROM orders;

SELECT MIN(ship_charge) FROM orders;

SELECT AVG(ship_charge) FROM orders;


-- 11.Realizar una consulta que muestre el número de orden, fecha de orden y fecha de embarque de todas que fueron 
-- embarcadas (ship_date) en el mismo mes que fue dada de alta la orden (order_date)


SELECT order_num, order_date, ship_date FROM orders
WHERE MONTH(ship_date) = MONTH(order_date);


-- 12.Obtener la Cantidad de embarques y Costo total (ship_charge) del embarque por número de clientey por 
-- fecha de embarque.Ordenar los resultados por el total de costo en orden inverso


SELECT COUNT(ship_date) cantidad_de_embarques, SUM(ship_charge) costo_total FROM orders
GROUP BY customer_num, ship_date
ORDER BY costo_total DESC;



-- 13.Mostrar fecha de embarque (ship_date) y cantidad total de libras(ship_weight) por día, de aquellos días cuyo 
-- peso de los embarques superen las 30 libras. Ordenar el resultado por el total delibras en orden descendente.


SELECT ship_date, SUM(ship_weight) peso_total from orders
GROUP BY ship_date
HAVING SUM(ship_weight) > 30
ORDER BY SUM(ship_weight) DESC;




