/*
SELECT 
    COUNT (*),
    COUNT (1),
    COUNT(idcliente) -- Menos perfomático para milhões de linhas 
FROM clientes
*/

/*
SELECT 
    DISTINCT idCliente
FROM clientes
*/


SELECT 
    DISTINCT flTwitch, flEmail -- Nesse caso ele traz as combinações únicas!
FROM clientes
