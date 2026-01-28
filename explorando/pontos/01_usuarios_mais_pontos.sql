/* Criar uma tabela com:
    10 usuários que mais OBTIVERAM pontos em toda a base,
    Quantos pontos trocaram,
    Sua idade na base,
    Número de transações,
    Produto mais comprado (pontos negativos!)
*/

WITH 

tb_clientes_pontos AS(
    SELECT
        idcliente,
        SUM(CASE WHEN qtdepontos >= 0 THEN qtdepontos END) AS pontospositivos,
        SUM(CASE WHEN qtdepontos < 0 THEN qtdepontos END) AS pontostrocados,
        COUNT(idtransacao) AS contagemtransacao,
        MIN(substr(dtcriacao, 0, 11)) AS dtcriacao,
        julianday('2026-01-26') - julianday(MIN(substr(dtcriacao, 0, 11))) AS idade
    FROM
        transacoes
    GROUP BY
        idcliente
),

tb_clientes_produtos_trocados AS (
    SELECT
        t1.idcliente,
        t2.idproduto,
        COUNT(t1.idtransacao) AS frequencia,
        ROW_NUMBER() OVER(PARTITION BY t1.idcliente ORDER BY COUNT(t1.idtransacao)DESC) AS rn,
        t3.descnomeproduto AS produto
    FROM
        transacoes AS t1
    LEFT JOIN
        transacao_produto AS t2
    ON
        t1.idtransacao = t2.idtransacao
    LEFT JOIN
        produtos AS t3
    ON
        t2.idproduto = t3.idproduto
    WHERE
        t2.vlproduto < 0
    GROUP BY
        t1.idcliente, t2.idproduto
    ORDER BY
        t1.idcliente
),

tb_clientes_produtos_adquiridos AS (
    SELECT
        t1.idcliente,
        t2.idproduto,
        COUNT(t1.idtransacao) AS frequencia,
        ROW_NUMBER() OVER(PARTITION BY t1.idcliente ORDER BY COUNT(t1.idtransacao)DESC) AS rn,
        t3.descnomeproduto AS produto
    FROM
        transacoes AS t1
    LEFT JOIN
        transacao_produto AS t2
    ON
        t1.idtransacao = t2.idtransacao
    LEFT JOIN
        produtos AS t3
    ON
        t2.idproduto = t3.idproduto
    WHERE
        t2.vlproduto > 0
    GROUP BY
        t1.idcliente, t2.idproduto
    ORDER BY
        t1.idcliente
)

SELECT 
    t1.*,
    t2.idproduto AS produtomaistrocado,
    t2.frequencia AS freq_trocado,
    t2.produto,
    t3.idproduto AS produtomaisadquirido,
    t3.frequencia AS freq_adquirido,
    t3.produto
FROM
    tb_clientes_pontos AS t1
LEFT JOIN
    tb_clientes_produtos_trocados AS t2
ON
    t1.idcliente = t2.idcliente
LEFT JOIN
    tb_clientes_produtos_adquiridos AS t3
ON
    t2.idcliente = t3.idcliente
WHERE
    t2.rn = 1
    AND
    t3.rn = 1
ORDER BY
    t1.pontospositivos DESC
LIMIT 10
