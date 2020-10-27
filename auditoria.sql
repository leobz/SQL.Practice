-- Creacion de tabla temporal clientes
SELECT TOP(10) * INTO #clientes FROM customer 
GO;

-- Creacion de Procedure auditarClientes
CREATE PROCEDURE auditarClientes
AS 
SELECT * FROM #clientes 
GO;

-- Ejecutar Procedure
EXEC auditarClientes;