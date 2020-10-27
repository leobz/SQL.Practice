-- 1 Crear una tabla temporal #clientes a partir de la siguiente consulta:
-- SELECT * FROM customer

SELECT * 
INTO #clientes
FROM customer

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


SELECT * INTO #temporal 
FROM #clientes WHERE customer_num = 103;

UPDATE #temporal
SET customer_num = 155;

SELECT * INTO #clientes
FROM #temporal;

SELECT * FROM #temporal;




--14
-- SELECT *
-- FROM customer
-- WHERE state = 'CA'
-- ORDER BY company;


-- 15. Obtener un listado de la cantidad de productos únicos comprados a cada fabricante, en donde el total
-- comprado a cada fabricante sea mayor a 1500. El listado deberá estar ordenado por cantidad de productos
-- comprados de mayor a menor.
-- SELECT *
-- FROM products, items
-- ORDER BY quantity;