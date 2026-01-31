WITH 

alunos_prim_dia AS (
    SELECT 
        DISTINCT idcliente AS alunos_prim_dia
    FROM
        transacoes
    WHERE
        substr(dtcriacao, 0, 11) = '2025-08-25'
),

tb_join AS(
    SELECT
        t1.alunos_prim_dia,
        COUNT(t2.idtransacao) AS transacao,
        substr(t2.dtcriacao, 0, 11) AS dtdia
    FROM
        alunos_prim_dia AS t1
    LEFT JOIN 
        transacoes AS t2
    ON
        t1.alunos_prim_dia = t2.idcliente
    AND
        substr(t2.dtcriacao, 0, 11) >= '2025-08-25'
    AND
        substr(t2.dtcriacao, 0, 11) < '2025-08-30'
    GROUP BY
        t1.alunos_prim_dia, dtdia
    ORDER BY
        t1.alunos_prim_dia, dtdia
),

tb_rn AS (
    SELECT *,
        row_number()
        OVER
        (PARTITION BY alunos_prim_dia 
        ORDER BY transacao DESC,
        dtdia) AS rn
    FROM tb_join
)

SELECT 
    alunos_prim_dia,
    transacao,
    dtdia
FROM 
    tb_rn
WHERE
    rn = 1