/*
SELECT 
    COUNT(DISTINCT idcliente)
FROM
    transacoes as t1
WHERE
    t1.idcliente IN (
        SELECT DISTINCT idcliente
        FROM transacoes
        WHERE substr(dtcriacao, 0, 11) = '2025-08-25'
    )
AND
    substr(dtcriacao, 0, 11) = '2025-08-29'
*/

WITH tb_cliente_primeiro_dia AS (
    SELECT DISTINCT idcliente AS idcliente1
    FROM transacoes
    WHERE substr(dtcriacao, 0, 11) = '2025-08-25'
),

tb_cliente_ultimo_dia AS (
    SELECT DISTINCT idcliente AS idcliente2
    FROM transacoes
    WHERE substr(dtcriacao, 0, 11) = '2025-08-29'
),

tb_join AS (
    SELECT *
    FROM
        tb_cliente_primeiro_dia AS t1
    LEFT JOIN
        tb_cliente_ultimo_dia AS t2
    ON
        t1.idcliente1 = t2.idcliente2
)

SELECT 
    COUNT(idcliente1),
    COUNT(idcliente2),
    1. * COUNT(idcliente2) / COUNT(idcliente1)
FROM
    tb_join