/*
-- Trazer o nome do produto á partir do ID do produto
SELECT 
    t1.*,
    t2.descnomeproduto

FROM 
    transacao_produto AS t1

LEFT JOIN 
    produtos AS t2
    ON 
    t1.IdProduto = t2.IdProduto
*/

/*
-- Qual categoria tem mais produtos vendidos?
SELECT 
    COUNT(t1.idproduto),
    t2.desccategoriaproduto

FROM 
    transacao_produto AS t1

INNER JOIN
    produtos AS t2
    ON
    t1.idproduto = t2.idproduto

GROUP BY
    t2.desccategoriaproduto

ORDER BY
    1 DESC;
*/

/*
-- Em 2024, quantas transações de Lovers tivemos?
SELECT 
    COUNT(t1.idTransacaoProduto),
    t3.desccategoriaproduto

FROM transacao_produto AS t1

LEFT JOIN
    transacoes as t2
    ON
    t1.IdTransacao = t2.IdTransacao

LEFT JOIN
    produtos as t3
    ON
    t1.idproduto = t3.idproduto

WHERE
    t2.dtcriacao > '2023-12-31'
    AND
    t2.dtcriacao < '2025-01-01'
    AND 
    t3.desccategoriaproduto = 'lovers'

GROUP BY
    t3.desccategoriaproduto;
*/

/*
-- Qual mês tivemos mais lista de presença assinada?
SELECT
    substr(t1.dtcriacao, 1, 7) AS AnoMês,
    COUNT(t2.idtransacao) AS ContagemPresenca

FROM
    transacoes AS t1

LEFT JOIN
    transacao_produto AS t2
    ON
    t1.idtransacao = t2.idTransacao

LEFT JOIN
    produtos AS t3
    ON
    t2.idproduto = t3.idproduto

WHERE 
    t3.descnomeproduto = 'Lista de presença'

GROUP BY
    AnoMês

ORDER BY
    ContagemPresenca DESC

LIMIT 1;
*/

/*
-- Qual o total de pontos trocados no Stream Elements em Junho de 2025?
SELECT
    SUM(t1.qtdepontos) AS PontosTrocados

FROM
    transacoes AS t1

LEFT JOIN
    transacao_produto AS t2
    ON
    t1.idtransacao = t2.idTransacao

LEFT JOIN
    produtos AS t3
    ON
    t2.idproduto = t3.idproduto

WHERE 
    t3.descnomeproduto = 'Troca de Pontos StreamElements'
    AND
    substr(t1.dtcriacao, 0,11) < '2025-07-01'
    AND
    substr(t1.dtcriacao, 0,11) > '2025-05-31';
*/