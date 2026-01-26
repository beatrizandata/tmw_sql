-- Todos esses meios retornarão a contagem de linhas 
SELECT
    COUNT(*),
    COUNT(1),
    COUNT(idcliente) -- caso menos perfomático para milhões de linhas
FROM 
    clientes;


SELECT
    COUNT(DISTINCT(idcliente))
FROM
    clientes;

-- Esse método de combinar colunas diferentes com o DISTINCT retorna as combinações únicas EXISTENTES 
SELECT
    DISTINCT fltwitch, flemail, flinstagram
FROM 
    clientes;

-- "Prova":
SELECT
    idcliente,
    fltwitch,
    flemail,
    flinstagram
FROM
    clientes
WHERE
    flinstagram = 1; -- Não existe um meio de conectar o sistema do TMW a uma conta instagram.
