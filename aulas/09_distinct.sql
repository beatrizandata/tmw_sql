SELECT
    COUNT(DISTINCT idcliente)
FROM
    transacoes
WHERE 
    dtcriacao >= '2025-07-01'
    AND
    dtcriacao < '2025-08-01'