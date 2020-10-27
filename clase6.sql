-- 1) Pasar a su forma equivalente

SELECT lname+' ,'+fname, customer_num
FROM customer
WHERE customer_num IN (
    SELECT customer_num
    FROM cust_calls
    GROUP BY customer_num 
    HAVING COUNT (*) >1 )



SELECT lname+' ,'+fname, cc.customer_num
FROM customer cn 
JOIN cust_calls cc ON (cn.customer_num = cc.customer_num)
GROUP BY lname+' ,'+fname, cc.customer_num
HAVING COUNT (*) >1




SELECT COUNT(*)
FROM customer
WHERE city = 
    (SELECT city FROM customer
    WHERE lname = 'Higgins')

SELECT COUNT(*)
FROM customer c1 JOIN customer c2 ON
    (c1.city = c2.city)
WHERE c2.lname = 'Higgins';

SELECT COUNT(*)
FROM customer
WHERE lname = 'Higgins'





-- JOINS (Group by, having, Subqueries, subq. correlacionados, outer joins, Temp tables)

-- 1. Mostrar el Código del fabricante, nombre del fabricante, tiempo de entrega y monto
-- Total de productos vendidos, ordenado por nombre de fabricante. En caso que el
-- fabricante no tenga ventas, mostrar el total en NULO.


select m.manu_code,manu_name,lead_time,SUM(quantity*unit_price) from items i
join manufact m on (m.manu_code=i.manu_code)
group by m.manu_code,manu_name,lead_time
order by 2



SELECT i.manu_code, manu_name, ship_date, SUM (i.quantity * i.unit_price) 
FROM manufact, orders, items i
    JOIN manufact.;

-- 2.Mostrar una lista de a pares, de todos los fabricantes que fabriquen el mismo producto.
--  En el caso que haya un único fabricante deberá mostrar el Código de fabricante 2 en nulo. 
--  El listado debe tener el siguiente formato: 
--  Nro. de Producto        Descripcion     Cód. de fabric. 1   Cód. de fabric. 2 
-- (stock_num)             (Description)   (manu_code)          (manu_code) 


SELECT pt.stock_num Nro_de_Producto, pt.description Descripcion, p1.manu_code Cód_de_fabric_1, p2.manu_code Cód_de_fabric_2
FROM product_types pt
    JOIN products p1 ON (p1.stock_num = pt.stock_num)
    JOIN products p2 ON (p2.stock_num = pt.stock_num)
WHERE p1.manu_code != p2.manu_code;



-- 3.Listar todos los clientes que hayan tenido más de una orden. 
-- a)En primer lugar, escribir una consulta usando una subconsulta. 
-- b)Reescribir la consulta  usando dos sentencias SELECT y una tabla temporal. 
-- c)Reescribir la consulta utilizando GROUP BY y HAVING. La consulta deberá tener el siguiente formato: 
-- Número_de_Cliente   Nombre   Apellido 
-- (customer_num)      (fname)  (lname)

-- a)En primer lugar, escribir una consulta usando una subconsulta. 
SELECT c.customer_num, c.fname, c.lname 
FROM customer c
WHERE c.customer_num 
    IN (
        SELECT customer_num
        FROM orders
        GROUP BY customer_num
        HAVING COUNT(order_num) > 1);

-- b)Reescribir la consulta  usando dos sentencias SELECT y una tabla temporal. 
SELECT c.customer_num, c.fname, c.lname, order_num
INTO #clientes_join_orders
FROM customer c
    JOIN orders ON (c.customer_num = orders.customer_num);

SELECT customer_num, fname, lname 
FROM #clientes_join_orders
GROUP BY customer_num, fname, lname
HAVING COUNT(order_num) > 1;

-- c)Reescribir la consulta utilizando GROUP BY y HAVING. La consulta deberá tener el siguiente formato: 
SELECT c.customer_num, c.fname, c.lname
FROM customer c
    JOIN orders o ON (o.customer_num = c.customer_num)
GROUP BY c.customer_num, c.fname, c.lname
HAVING COUNT(order_num) > 1



-- 4. Seleccionar todas las Órdenes de compra cuyo Monto total (Suma de p x q de sus items)
-- sea menor al precio total promedio (avg p x q) de todos los ítems de todas las ordenes.
-- Formato de la salida: 
-- Nro. de Orden Total
-- (order_num) (suma)

SELECT order_num, (unit_price * quantity) total_price
FROM items
WHERE 
    (unit_price * quantity) < (
        SELECT AVG(unit_price * quantity)
        FROM items
    );


-- 5.Obtener por cada fabricante, el listado de todos los productos de stock con precio unitario (unit_price) 
-- mayor que el precio unitario promedio para dicho fabricante.  
-- Los campos de salida serán: manu_code, manu_name, stock_num, description, unit_price. 
-- Por ejemplo: 
--     El precio unitario promedio de los productosfabricados por ANZ es $180.23. se debe
--     incluir en su lista todos los productos de ANZ que tenganun precio unitario superior adicho importe. 


-- Promedio de cada fabricante
SELECT manu_code, AVG(unit_price) promedio
FROM products
GROUP BY manu_code;


-- Consulta final v1
SELECT p1.manu_code, manu_name, p1.stock_num, description, p1.unit_price
FROM products p1
    JOIN manufact m ON (m.manu_code = p1.manu_code)
    JOIN product_types pt ON (pt.stock_num = p1.stock_num)
WHERE EXISTS (
    SELECT manu_code, AVG(unit_price) promedio
    FROM products p2
    WHERE p2.manu_code = p1.manu_code
    GROUP BY manu_code
    HAVING p1.unit_price > AVG(unit_price)
)

-- Consulta final v2

SELECT p1.manu_code, manu_name, p1.stock_num, description, p1.unit_price
FROM products p1
    JOIN manufact m ON (m.manu_code = p1.manu_code)
    JOIN product_types pt ON (pt.stock_num = p1.stock_num)
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM products p2
    WHERE p2.manu_code = p1.manu_code
)



-- 6- Usando el operador NOT EXISTS listar la información de órdenes de compra que 
-- NO incluyan ningún producto que contenga en su descripción el string ‘baseball gloves’.
-- Ordenar el resultado por compañía del cliente ascendente y número de orden descendente. 
-- El formato de salida deberá ser:
-- Número de Cliente   Compañía    Número de Orden Fecha de la Orden 
-- (customer_num)      (company)   (order_num)     (order_date)

SELECT c.customer_num, c.company, order_num, order_date
FROM customer c
    JOIN orders o ON (o.customer_num = c.customer_num)
WHERE NOT EXISTS (
    SELECT order_num
    FROM items i
        JOIN product_types pt ON (pt.stock_num = i.stock_num)
    WHERE [description] LIKE '%baseball gloves%' AND
    i.order_num = o.order_num
)
ORDER BY company, order_num DESC




-- Operador UNION

-- 7. Reescribir la siguiente consulta utilizando el operador UNION: 
-- SELECT * FROM products WHERE manu_code = ‘HRO’OR stock_num = 1

-- Original
SELECT * FROM products WHERE manu_code = 'HRO' OR stock_num = 1

-- Union version
SELECT * FROM products WHERE manu_code = 'HRO' 
UNION 
SELECT * FROM products WHERE stock_num = 1




-- 8.Desarrollar una consulta que devuelva las ciudades y compañías de todos los Clientes ordenadas alfabéticamente 
-- por Ciudad pero en la consulta deberán aparecer primero las compañías situadas en Redwood City y luego las demás.
-- Formato:
-- Clave de ordenamiento   Ciudad  Compañía 
-- (sortkey)               (city)  (company) 


SELECT 1 sortkey, city, company 
FROM customer
WHERE city = 'Redwood City'
UNION
SELECT 2 sortkey, city, company 
FROM customer
WHERE city != 'Redwood City';


-- 9. Desarrollar una consulta que devuelva los dos tipos de productos más vendidos y los
-- dos menos vendidos en función de las unidades totales vendidas.
-- Formato:
-- TipoProducto    Cantidad

-- Tablas separadas (Maximas y minimas ventas)

SELECT TOP 2 stock_num, SUM(quantity) total_quantity
FROM items
GROUP BY stock_num
ORDER BY SUM(quantity) DESC

SELECT TOP 2 stock_num, SUM(quantity) total_quantity
FROM items
GROUP BY stock_num
ORDER BY SUM(quantity);

-- Uniendo las dos tablas

SELECT  stock_num, SUM(quantity) total_quantity
    FROM items
    WHERE stock_num IN (
        SELECT TOP 2 stock_num
        FROM items
        GROUP BY stock_num
        ORDER BY SUM(quantity) DESC
    )
    GROUP BY stock_num
UNION
SELECT stock_num, SUM(quantity) total_quantity
    FROM items
    WHERE stock_num IN (
        SELECT TOP 2 stock_num
        FROM items
        GROUP BY stock_num 
        ORDER BY SUM(quantity)
    )
    GROUP BY stock_num
ORDER BY 2 DESC;




-- VISTAS
-- 10. Crear una Vista llamada ClientesConMultiplesOrdenes basada en la consulta realizada en
-- el punto 3.c con los nombres de atributos solicitados en dicho punto.


CREATE VIEW ClientesConMultiplesOrdenes
(codigo, apellido, nombre)
AS 
SELECT c.customer_num, c.fname, c.lname
FROM customer c
    JOIN orders o ON (o.customer_num = c.customer_num)
GROUP BY c.customer_num, c.fname, c.lname
HAVING COUNT(order_num) > 1;

-- Comprobacion
SELECT * 
FROM ClientesConMultiplesOrdenes;

-- 11. Crear una Vista llamada Productos_HRO en base a la consulta
-- SELECT * FROM products
-- WHERE manu_code = “HRO”

CREATE VIEW Productos_HRO 
AS
SELECT * FROM products
WHERE manu_code = 'HRO'

SELECT *
FROM Productos_HRO



-- La vista deberá restringir la posibilidad de insertar datos que no cumplan con su criterio
-- de selección.
-- a. Realizar un INSERT de un Producto con manu_code=’ANZ’ y stock_num=303. Qué
-- sucede?

INSERT INTO Productos_HRO 
(stock_num, manu_code) VALUES (303, 'ANZ')
-- RTA: SE AGREGA PERO NO SE VE

-- b. Realizar un INSERT con manu_code=’HRO’ y stock_num=303. Qué sucede?

INSERT INTO Productos_HRO 
(stock_num, manu_code) VALUES (303, 'HRO')
-- RTA: SE AGREGA Y SE VE

-- c. Validar los datos insertados a través de la vista.
SELECT *
FROM Productos_HRO
WHERE stock_num = 303

-- RTA: SOLO SE VE LA QUE ES CON "HRO"


-- TRANSACCIONES


-- 12.
-- Escriba una transacción que incluya las siguientes acciones:
-- • BEGIN TRANSACTION
--      o Insertar un nuevo cliente llamado “Fred Flintstone” en la tabla de
--        clientes (customer).
--      o Seleccionar todos los clientes llamados Fred de la tabla de clientes
--        (customer).
-- • ROLLBACK TRANSACTION


BEGIN TRANSACTION 
    INSERT INTO customer (customer_num, fname) VALUES (12345, 'Fred Flinstone')
    SELECT * from customer WHERE fname LIKE 'Fred Flinstone'
ROLLBACK TRANSACTION

-- Luego volver a ejecutar la consulta
-- • Seleccionar todos los clientes llamados Fred de la tabla de clientes (customer).
-- • Completado el ejercicio descripto arriba. Observar que los resultados del
-- segundo SELECT difieren con respecto al primero.
SELECT * from customer WHERE fname LIKE 'Fred Flinstone'



-- 13.
-- Se ha decidido crear un nuevo fabricante AZZ, quién proveerá parte de los mismos
-- productos que provee el fabricante ANZ, los productos serán los que contengan el string
-- ‘tennis’ en su descripción.
--  • Agregar las nuevas filas en la tabla manufact y la tabla products.
--  • El código del nuevo fabricante será “AZZ”, el nombre de la compañía “AZZIO SA”
--    y el tiempo de envío será de 5 días (lead_time).
--  • La información del nuevo fabricante “AZZ” de la tabla Products será la misma
--    que la del fabricante “ANZ” pero sólo para los productos que contengan 'tennis'
--    en su descripción.
--  • Tener en cuenta las restricciones de integridad referencial existentes, manejar
--    todo dentro de una misma transacción.

BEGIN TRANSACTION
    INSERT INTO manufact (manu_code, manu_name, lead_time, [state], f_alta_audit, d_usualta_audit)
    SELECT 'AZZ', 'AZZIO SA', lead_time, [state], f_alta_audit, d_usualta_audit
    FROM manufact WHERE manu_code = 'ANZ';


    INSERT INTO product_types
    SELECT p.stock_num*99, [description]
    FROM product_types pt
    JOIN products p ON (p.stock_num = pt.stock_num)
    WHERE [description] LIKE '%tennis%' AND
    manu_code = 'ANZ';
    

    INSERT INTO products (stock_num, manu_code, unit_price, unit_code)
    SELECT pt.stock_num*99 , 'AZZ', unit_price, unit_code
    FROM products
    JOIN product_types pt ON (pt.stock_num = products.stock_num)
    WHERE manu_code = 'ANZ' AND [description] LIKE '%tennis%'

    SELECT * FROM products WHERE manu_code = 'AZZ';
ROLLBACK TRANSACTION

