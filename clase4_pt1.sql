-- Clase 4 parte 1


-- 14 Crear una consulta que liste todos los clientes que vivan en California ordenados por compañía.

SELECT * FROM customer
WHERE state = 'CA'
ORDER BY company;


-- 15 Obtener un listado de la cantidad de productos únicos comprados a cada fabricante, en donde el total
-- comprado a cada fabricante sea mayor a 1500. El listado deberá estar ordenado por cantidad de productos
-- comprados de mayor a menor.

SELECT manu_code, COUNT(item_num) total_comprado FROM items
WHERE (quantity * unit_price) > 1500
GROUP BY manu_code
ORDER BY total_comprado;


-- 16. Obtener un listado con el código de fabricante, nro de producto, la cantidad vendida (quantity), y el total
-- vendido (quantity x unit_price), para los fabricantes cuyo código tiene una “R” como segunda letra. Ordenar
-- el listado por código de fabricante y nro de producto.

SELECT manu_code, stock_num, quantity, (quantity * unit_price) total_vendido from items
WHERE manu_code LIKE '_R%'
ORDER BY manu_code,  stock_num;



-- 17. Crear una tabla temporal OrdenesTemp que contenga las siguientes columnas: cantidad de órdenes por
-- cada cliente, primera y última fecha de orden de compra (order_date) del cliente. Realizar una consulta de
-- la tabla temp OrdenesTemp en donde la primer fecha de compra sea anterior a '2015-05-23 00:00:00.000',
-- ordenada por fechaUltimaCompra en forma descendente.

SELECT customer_num, COUNT(order_num) cantidad_ordenes, MIN(order_date) fecha_primer_orden, MAX(order_date) fecha_ultima_orden 
INTO #ordenesTemp FROM orders
GROUP BY customer_num;

SELECT * FROM #ordenesTemp
WHERE fecha_primer_orden < CAST('2015-05-23' AS DATE);


-- 18. Consultar la tabla temporal del punto anterior y obtener la cantidad de clientes con igual cantidad de
-- compras. Ordenar el listado por cantidad de compras en orden descendente


SELECT * from #ordenesTemp;

SELECT cantidad_ordenes, COUNT(customer_num) cantidad_clientes FROM #ordenesTemp
GROUP BY cantidad_ordenes
ORDER BY cantidad_ordenes DESC;


-- 19. Desconectarse de la sesión. Volver a conectarse y ejecutar SELECT * from #ordenesTemp.
-- Que sucede?

-- Rta : Desaparce porque es una tabla de sesion



-- 20. Se desea obtener la cantidad de clientes por cada state y city, donde los clientes contengan el string
-- ‘ts’ en el nombre de compañía, el código postal este entre 93000 y 94100 y la ciudad no sea 'Mountain View'. Se
-- desea el listado ordenado por ciudad


SELECT state, city, COUNT(customer_num) cantidad_clientes from customer
WHERE company LIKE '%ts%' AND
zipcode BETWEEN 93000 AND 94100 AND
city != 'Mountain View'
GROUP BY state, city
ORDER BY state;



-- 21. Para cada estado, obtener la cantidad de clientes referidos. Mostrar sólo los clientes que hayan sido
-- referidos cuya compañía empiece con una letra que este en el rango de ‘A’ a ‘L’.

SELECT state, COUNT(customer_num_referedBy) cantidad_clientes_referidos from customer
WHERE company LIKE '[A-L]%'
GROUP BY state;


-- 22. Se desea obtener el promedio de lead_time por cada estado, donde los Fabricantes tengan una ‘e’ en
-- manu_name y el lead_time sea entre 5 y 20.

SELECT state, AVG(lead_time) lead_time_promedio FROM manufact
WHERE manu_name LIKE '%e%' AND
lead_time BETWEEN 5 AND 20
GROUP BY state;


-- 23. Se tiene la tabla units, de la cual se quiere saber la cantidad de unidades que hay por cada tipo (unit) que no
-- tengan en nulo el descr_unit, y además se deben mostrar solamente los que cumplan que la cantidad
-- mostrada se superior a 5. Al resultado final se le debe sumar 1

SELECT unit, COUNT(unit_code) cantidad_de_unidades FROM units
WHERE unit_descr IS NOT NULL
GROUP BY unit
HAVING COUNT(unit_code) > 5;