/*
-- Lista de transações com apenas 1 ponto
SELECT IdTransacao, QtdePontos
FROM transacoes
WHERE QtdePontos = 1;
*/

/*
-- Lista de pedidos realizados no fim de semana
SELECT  IdTransacao, 
        DtCriacao,
        datetime(substr(DtCriacao, 1, 19)) AS DataHora,
        strftime('%w', datetime(substr(DtCriacao, 1, 19))) AS DiaSemana
FROM transacoes
WHERE DiaSemana = '6' or '0';
*/

/*
-- Lista de clientes com 0 pontos
SELECT idCliente, qtdePontos
FROM clientes
WHERE qtdePontos = 0;
*/

/*
-- Lista de clientes com 100 a 200 pontos (inclusive)
SELECT idCliente, qtdePontos
FROM clientes
WHERE qtdePontos >= '100' AND qtdePontos <= '200'; -- Não pode ser OR!!!
--WHERE qtdePontos BETWEEN 100 and 200, ele é INCLUSIVE
*/

/*
-- Lista de produtos com nome que começa com "Venda de"
SELECT IdProduto, DescNomeProduto
FROM produtos
WHERE DescNomeProduto LIKE 'Venda de%';
*/

/*
-- Lista de produtos com nome que termina com "Lover"
SELECT IdProduto, DescNomeProduto
FROM produtos
WHERE DescNomeProduto LIKE '%Lover';
*/

/*
-- Lista de produtos que são "chapéu"
SELECT IdProduto, DescNomeProduto
FROM produtos
WHERE DescNomeProduto LIKE '%Chapéu%';
*/

/*
-- Lista de transações com o produto "Resgatar Ponei"
SELECT idTransacaoProduto, IdProduto
FROM transacao_produto
WHERE IdProduto = 15;
*/

/*
-- Listar todas as transações adicionando uma coluna nova sinalizando "alto", "medio", "baixo" para o valor dos pontos, sendo: [<10; <500; >=500]
SELECT 
    IdTransacao,
    QtdePontos,
    CASE 
        WHEN QtdePontos < 10 THEN 'Baixo'
        WHEN QtdePontos < 500 THEN 'Médio'
        WHEN QtdePontos >= 500 THEN 'Alto'
    END AS ClassificacaoPontos
FROM transacoes;
*/