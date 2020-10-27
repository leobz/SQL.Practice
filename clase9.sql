-- a Stored Procedures
-- 1. Crear la tabla CustomerStatistics con los siguientes campos customer_num
-- (entero y pk), ordersQty (entero), maxDate (date), productsQty (entero)

DROP TABLE CustomerStatistics;

CREATE TABLE CustomerStatistics (
    customer_num INT IDENTITY(1,1) PRIMARY KEY,
    ordersQty INT,
    maxDate DATETIME,
    productsQty INT
);


-- 2. Crear un procedimiento ‘CustomerStatisticsUpdate’ que reciba el parámetro
-- fecha_DES (date) y que en base a los datos de la tabla Customer, inserte (si
-- no existe) o actualice el registro de la tabla CustomerStatistics con la
-- siguiente información:
-- ordersqty: cantidad de órdenes para cada cliente + las nuevas
-- órdenes con fecha mayor o igual a fecha_DES
-- maxDate: fecha de la última órden del cliente.
-- productsQty: cantidad única de productos adquiridos por cada
-- cliente histórica

CREATE PROCEDURE CustomerStatisticsUpdate @fecha_DES DATETIME
AS
    INSERT INTO CustomerStatisticsUpdate (ordersQty, productsQty)
    VALUES (1, 1)
;


CREATE PROCEDURE CustomerProc
AS
    INSERT INTO CustomerStatisticsUpdate (ordersQty, productsQty)
    VALUES (1, 1)
;

EXEC CustomerProc;

EXEC CustomerStatisticsUpdate @fecha_DES = GETDATE();