-- 1 Crear una tabla temporal #clientes a partir de la siguiente consulta:
-- SELECT * FROM customer

SELECT *
INTO #clientes
FROM customer;

SELECT * 
FROM #clientes;



-- 2 Insertar el siguiente cliente en la tabla #clientes
-- Customer_num 144
-- Fname Agustín
-- Lname Creevy
-- Company Jaguares SA
-- State CA
-- City Los Angeles

INSERT INTO #clientes(customer_num, fname, lname, company, state, city) 
VALUES (144, 'Agustin', 'Creevy', 'Jaguares SA', 'CA', 'Los Angeles');

SELECT *
FROM #clientes WHERE customer_num = 144;


-- 3 Crear una tabla temporal #clientesCalifornia con la misma estructura de la tabla customer.
-- Realizar un insert masivo en la tabla #clientesCalifornia con todos los clientes de la tabla customer cuyo
-- state sea CA.

SELECT * INTO #clientesCalifornia
FROM customer
WHERE state = 'CA';

SELECT *
FROM #clientesCalifornia;


-- 4 Insertar el siguiente cliente en la tabla #clientes un cliente que tenga los mismos datos del cliente 103,
-- pero cambiando en customer_num por 155
-- Valide lo insertado.




INSERT INTO #clientes (customer_num, fname, lname, company, state, city)
SELECT 155, fname, lname, company, state, city
FROM #clientes
WHERE customer_num = 103;

select * from #clientes
where customer_num = 103 or customer_num = 155;



-- 5 Borrar de la tabla #clientes los clientes cuyo campo zipcode esté entre 94000 y 94050 y la ciudad
-- comience con ‘M’. Validar los registros a borrar antes de ejecutar la acción.



DELETE FROM #clientes
where zipcode BETWEEN 94000 AND 94050;

-- Comprobacion
SELECT * FROM customer
WHERE zipcode BETWEEN 94000 AND 94050;

SELECT * FROM #clientes
WHERE zipcode BETWEEN 94000 AND 94050;





-- 6 Borrar de la tabla #clientes todos los clientes que no posean órdenes de compra en la tabla orders.
-- (Utilizar un subquery).


DELETE FROM #clientes
WHERE customer_num NOT IN (SELECT customer_num FROM orders);

-- Comprobacion

SELECT * FROM #clientes
WHERE customer_num NOT IN (SELECT customer_num FROM orders);




-- 7 Modificar los registros de la tabla #clientes cambiando el campo state por ‘AK’ y el campo address2 por
-- ‘Barrio Las Heras’ para los clientes que vivan en el state 'CO'. Validar previamente la cantidad de
-- registros a modificar.

UPDATE #clientes
SET state = 'AK', address2 = 'Barrio Las Heras'
WHERE state = 'CO';



--Compobacion

SELECT * FROM #clientes
WHERE state = 'AK';



-- 8 Modificar todos los clientes de la tabla #clientes, agregando un dígito 1 delante de cada número
-- telefónico, debido a un cambio de la compañía de teléfonos.

UPDATE #clientes
SET phone = '1' + phone; 

--Comprobacion

SELECT phone FROM #clientes;



