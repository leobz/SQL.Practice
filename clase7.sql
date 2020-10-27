--------------------------------------------------------------------------------
----------------------       Práctica de Triggers I    -------------------------

-- 1. Dada la tabla Products de la base de datos stores7 se requiere crear una tabla
-- Products_historia_precios y crear u

CREATE TABLE products_historia_precios(
    stock_historia_id INT IDENTITY(1,1 ),
    stock_num INT,
    manu_code CHAR(3),
    fechaHora DATETIME DEFAULT GETDATE(),
    usuario CHAR(20) DEFAULT USER_NAME(),
    unit_price_old DECIMAL,
    unit_price_new DECIMAL,
    estado CHAR(1) DEFAULT 'A'
    CHECK (estado IN ('A', 'I'))
)

SELECT * FROM products_historia_precios;

SELECT * FROM products;


-- 2. Crear un trigger sobre la tabla Products_historia_precios que ante un delete sobre la misma
-- realice en su lugar un update del campo estado de ‘A’ a ‘I’ (inactivo).

CREATE TRIGGER products_historia_precios ejercicio2 
ON products_historia_precios
INSTEAD OF DELETE AS 
BEGIN
    UPDATE products_historia_precios
    SET estado = 'I'
    WHERE stock_historia_id IN (SELECT stock_historia_id FROM deleted)
END;

