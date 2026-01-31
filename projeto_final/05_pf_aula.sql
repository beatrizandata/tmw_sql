/*
Projeto Final:
Vamos construir uma tabela com o perfil comportamental dos nossos usuários.

1. Quantidade de transações históricas (vida, D7, D14, D28, D56); OK
2. Dias desde a última transação; OK
3. Idade na base; OK
4. Produto mais usado (vida, D7, D14, D28, D56); OK
5. Saldo de pontos atual; OK
6. Pontos acumulados positivos (vida, D7, D14, D28, D56); OK
7. Pontos acumulados negativos (vida, D7, D14, D28, D56); OK
8. Dias da semana mais ativos (D28); 
9. Período do dia mais ativo (D28);
10. Engajamento em D28 versus Vida
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE feature_store_cliente AS

WITH 

tb_transacoes AS(
    SELECT
        idcliente,
        idtransacao,
        qtdepontos,
        date(dtcriacao) AS dtdia,
        CAST(strftime('%H', substr(dtcriacao, 1, 19)) AS INTEGER) AS hora, ------------
        ROUND(julianday('2025-07-01') - julianday(date(dtcriacao)), 0) AS diffdate
    FROM
        transacoes
    WHERE dtcriacao < '2025-07-01'
),

tb_cliente AS(
    SELECT
        idcliente,
        date(dtcriacao) AS dtdia,
        ROUND(julianday('2025-07-01') - julianday(date(dtcriacao)),0) AS idadebase -- 3
    FROM
        clientes
),

tb_sumario_transacoes AS(
    SELECT 
        idcliente,

        COUNT(idtransacao) AS t_vida, -- 1
        COUNT(CASE WHEN diffdate <= 7 THEN idtransacao END) as t_7, -- 1
        COUNT(CASE WHEN diffdate <= 14 THEN idtransacao END) as t_14, -- 1
        COUNT(CASE WHEN diffdate <= 28 THEN idtransacao END) as t_28, -- 1
        COUNT(CASE WHEN diffdate <= 56 THEN idtransacao END) as t_56, -- 1

        SUM(qtdepontos) AS saldopontos, -- 5

        SUM(CASE WHEN qtdepontos > 0 THEN qtdepontos ELSE 0 END) AS pp_vida, -- 6
        SUM(CASE WHEN qtdepontos > 0 AND diffdate <=  7 THEN qtdepontos ELSE 0 END) AS pp_7, -- 6
        SUM(CASE WHEN qtdepontos > 0 AND diffdate <= 14 THEN qtdepontos ELSE 0 END) AS pp_14, -- 6
        SUM(CASE WHEN qtdepontos > 0 AND diffdate <= 28 THEN qtdepontos ELSE 0 END) AS pp_28, -- 6
        SUM(CASE WHEN qtdepontos > 0 AND diffdate <= 56 THEN qtdepontos ELSE 0 END) AS pp_56, -- 6

        SUM(CASE WHEN qtdepontos < 0 THEN qtdepontos ELSE 0 END) AS pn_vida, -- 7
        SUM(CASE WHEN qtdepontos < 0 AND diffdate <=  7 THEN qtdepontos ELSE 0 END) AS pn_7, -- 7
        SUM(CASE WHEN qtdepontos < 0 AND diffdate <= 14 THEN qtdepontos ELSE 0 END) AS pn_14, -- 7
        SUM(CASE WHEN qtdepontos < 0 AND diffdate <= 28 THEN qtdepontos ELSE 0 END) AS pn_28, -- 7
        SUM(CASE WHEN qtdepontos < 0 AND diffdate <= 56 THEN qtdepontos ELSE 0 END) AS pn_56, -- 7


        MIN(diffdate) AS diasultimainteracao -- 2

    FROM 
        tb_transacoes
    GROUP BY
        idcliente
),

tb_transacao_produto AS (
    SELECT 
        t1.*,
        t3.descnomeproduto,
        t3.desccategoriaproduto
    FROM 
        tb_transacoes AS t1
    LEFT JOIN
        transacao_produto AS t2
    ON
        t1.idtransacao = t2.idtransacao
    LEFT JOIN
        produtos AS t3
    ON
        t2.idproduto = t3.idproduto
),

tb_cliente_produto AS(
    SELECT
        idcliente,
        descnomeproduto,
        COUNT(descnomeproduto) AS qtdevida,
        COUNT(CASE WHEN diffdate <=  7 THEN descnomeproduto END) AS qtde_7,
        COUNT(CASE WHEN diffdate <= 14 THEN descnomeproduto END) AS qtde_14,
        COUNT(CASE WHEN diffdate <= 28 THEN descnomeproduto END) AS qtde_28,
        COUNT(CASE WHEN diffdate <= 56 THEN descnomeproduto END) AS qtde_56
    FROM
        tb_transacao_produto
    GROUP BY
        idcliente, descnomeproduto
),

tb_cliente_produto_rn AS(
SELECT *,
    ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY qtdevida DESC) AS rnvida,
    ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY qtde_7 DESC) AS rn_7,
    ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY qtde_14 DESC) AS rn_14,
    ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY qtde_28 DESC) AS rn_21,
    ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY qtde_56 DESC) AS rn_28
FROM 
    tb_cliente_produto
),

tb_cliente_dia AS(
    SELECT 
        idcliente,
        strftime('%w', dtdia) AS dtdiagroup,
        COUNT(dtdia) AS contagem
    FROM 
        tb_transacoes
    WHERE
        diffdate <=28
    GROUP BY
        idcliente, dtdiagroup
    ORDER BY
        idcliente, dtdiagroup
),

tb_cliente_dia_favorito AS(
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY dtdiagroup DESC) AS rn
    FROM 
        tb_cliente_dia
),


tb_cliente_periodo AS(
    SELECT 
        idcliente,
        CASE 
            WHEN hora BETWEEN 7 AND 12 THEN 'manhã'
            WHEN hora BETWEEN 13 AND 18 THEN 'tarde'
            WHEN hora BETWEEN 19 AND 23 THEN 'noite'
            WHEN hora BETWEEN 24 AND 6 THEN 'madrugada'
            ELSE 'sem informacao'
        END AS periodo,
        COUNT(*) AS qtdtransacao
    FROM 
        tb_transacoes
    WHERE 
        diffdate <= 28
    GROUP BY
        idcliente, periodo
),

tb_cliente_periodo_rn AS(
    SELECT * ,
        ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY qtdtransacao DESC) AS rn
    FROM tb_cliente_periodo
),

tb_join AS (
    SELECT
        t2.idadebase,
        t1.*,
        t3.descnomeproduto AS pd_vida,
        t4.descnomeproduto AS pd_7,
        t5.descnomeproduto AS pd_14,
        t6.descnomeproduto AS pd_28,
        t7.descnomeproduto AS pd_56,
        COALESCE(t8.dtdiagroup, -1) AS diafav_28,
        COALESCE(t9.periodo, 'sem informacao') AS periodofav
    FROM
        tb_sumario_transacoes AS t1

    LEFT JOIN
        tb_cliente AS t2
    ON
        t1.idcliente = t2.idcliente

    LEFT JOIN
        tb_cliente_produto_rn AS t3
    ON
        t1.idcliente = t3.idcliente
    AND
        t3.rnvida = 1

    LEFT JOIN
        tb_cliente_produto_rn AS t4
    ON
        t1.idcliente = t4.idcliente
    AND
        t4.rn_7 = 1

    LEFT JOIN
        tb_cliente_produto_rn AS t5
    ON
        t1.idcliente = t5.idcliente
    AND
        t5.rn_14 = 1

    LEFT JOIN
        tb_cliente_produto_rn AS t6
    ON
        t1.idcliente = t6.idcliente
    AND
        t6.rn_28 = 1

    LEFT JOIN
        tb_cliente_produto_rn AS t7
    ON
        t1.idcliente = t7.idcliente
    AND
        t7.rn_28 = 1

    LEFT JOIN
        tb_cliente_dia_favorito AS t8
    ON
        t7.idcliente = t8.idcliente
    AND
        t8.rn = 1

    LEFT JOIN
        tb_cliente_periodo_rn AS t9
    ON
        t8.idcliente = t9.idcliente
    AND
        t9.rn = 1
)

SELECT 
    '2025-08-01' AS dtref,
    *,
    1. * t_28 / t_vida AS engajamento28
FROM
    tb_join