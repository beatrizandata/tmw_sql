-- Fluxo ideal

DELETE FROM relatorio_diario;

WITH 

tb_transacoes AS(
    SELECT 
        substr(dtcriacao, 0, 11) AS dtdia,
        COUNT(DISTINCT idtransacao) AS contagem
    FROM 
        transacoes
    GROUP BY 
        dtdia
    ORDER BY
        dtdia
),

tb_acumulada AS (
SELECT *,
    SUM(contagem) OVER (ORDER BY dtdia) AS acumulado
FROM
    tb_transacoes
)

INSERT INTO relatorio_diario -----------------

SELECT *
FROM tb_acumulada;

SELECT *
FROM
    relatorio_diario;