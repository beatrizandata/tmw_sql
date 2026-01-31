
DROP TABLE IF EXISTS relatorio_diario; -- Não é o mais recomendado porque usuários de BI perderão acesso

CREATE TABLE IF NOT EXISTS relatorio_diario AS

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

SELECT *
FROM tb_acumulada;

SELECT *
FROM
    relatorio_diario;
