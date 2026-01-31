-- Evolução diária (acumulada) de interações durante os dias de curso
/*
WITH 

tb_transacoes AS (
    SELECT 
        substr(dtcriacao, 0, 11) AS dtdia,
        COUNT(idtransacao) AS contagem
    FROM
        transacoes
    WHERE 
        dtdia >= '2025-08-25'
    AND
        dtdia < '2025-08-30'
    GROUP BY
        dtdia
)

SELECT *,
    SUM(contagem) 
    OVER 
    (ORDER BY dtdia) AS transacoes_acumuladas
FROM tb_transacoes
*/


/*
-- Evolução diária (acumulada) de interações durante os dias de curso por pessoa

-- Quanto cada pessoa transacionou por dia + acumulado

WITH

tb_alunos AS(
    SELECT
        idcliente,
        COUNT(DISTINCT idtransacao) transacoes,
        substr(dtcriacao, 0, 11) AS dtdia
    FROM
        transacoes
    WHERE
        substr(dtcriacao, 0, 11) >= '2025-08-25'
    AND
        substr(dtcriacao, 0, 11) < '2025-08-30'
    GROUP BY
        idcliente, dtdia
),

tb_lag AS(
    SELECT *,
        SUM(transacoes)
        OVER 
        (PARTITION BY idcliente ORDER BY dtdia) AS acumulado,

        LAG(transacoes) -- Empurra o valor da linha anterior para a linha atual
        OVER
        (PARTITION BY idcliente ORDER BY dtdia) AS lag

    FROM tb_alunos
)

SELECT *,
       transacoes - lag AS diferenca,
       1. * transacoes / lag AS diff -- Tendência
FROM tb_lag
*/



-- Qual a recorrência (intervalo) com que os alunos retornam ao Téo Me Why?

WITH cliente_dia AS(
    SELECT
        DISTINCT idcliente,
        substr(dtcriacao, 0, 11) AS dtdia
    FROM
        transacoes
    WHERE
        substr(dtcriacao, 0, 5) = '2025'
    ORDER BY
        idcliente, 
        dtdia ASC
),

tb_lag AS(
    SELECT *,
        LAG(dtdia) OVER
        (PARTITION BY idcliente ORDER BY dtdia) AS lagdia
    FROM cliente_dia
),

tb_diff_dt AS(
    SELECT *,
        julianday(dtdia) - julianday(lagdia) AS dtdiff
    FROM tb_lag
),

avg_cliente AS(
    SELECT
        idcliente,
        ROUND(AVG(dtdiff), 0) AS media_retorno
    FROM
        tb_diff_dt
    GROUP BY
        idcliente
)

SELECT 
    AVG(media_retorno)
FROM
    avg_cliente