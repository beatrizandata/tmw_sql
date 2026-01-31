-- Selecione todos os clientes com email cadastrado
SELECT idCliente, flEmail
FROM clientes
WHERE flEmail = 1;

-- Selecione todas as transações de 50 pontos (exatos)
SELECT IdTransacao, QtdePontos
FROM transacoes
WHERE QtdePontos = 50;

-- Selecione todos os clientes com mais de 500 pontos
SELECT idCliente, QtdePontos
FROM clientes
WHERE QtdePontos > 500;

-- Selecione produtos que contêm 'churn' no nome
SELECT *
FROM produtos

   -- WHERE DescNomeProduto pode ser com OR, IN e LIKE

WHERE DescNomeProduto LIKE 'churn%'; -- O mais custoso de todos pois busca dentro de cada string