/*
-- Quantos clientes tem email cadastrado?
SELECT 
    SUM(flemail) AS ClientesEmail,
FROM clientes;
*/

----------------------------------------------------------------------------------------------

/*
-- Qual cliente juntou mais pontos positivos em Maio de 2025?
SELECT 
    idcliente,
    SUM(qtdepontos) AS TotalPontos
FROM transacoes
WHERE 
    dtcriacao >= '2025-05-01'
    AND
    dtcriacao < '2025-06-01'
    AND
    qtdepontos > 0
GROUP BY
    idcliente
ORDER BY
    TotalPontos DESC
LIMIT 1;
*/

--------------------------------------------------------------------------------------------

/*
-- Qual cliente fez mais transações no ano de 2024?
SELECT 
    idcliente,
    COUNT(idtransacao) AS TotalTransacao -- NESSE caso não precisa de DISTINCT
FROM transacoes
WHERE
    dtcriacao >= '2024-01-01'
    AND
    dtcriacao < '2025-01-01'
    -- Jeito mais 'refinado': substr(dtcriacao, 1, 4) = '2024'
GROUP BY
    idcliente
ORDER BY
    TotalTransacao DESC
LIMIT 1;
*/

--------------------------------------------------------------------------------------------

/*
-- Quantos produtos são de rpg?
SELECT 
    COUNT(idproduto)
FROM produtos
WHERE 
    desccategoriaproduto = 'rpg';
*/

--------------------------------------------------------------------------------------------

/*
-- Qual o valor médio de pontos positivos por dia?
SELECT 
   COUNT(DISTINCT substr(dtcriacao, 0, 11)) AS DiasUnicos,
   SUM(qtdepontos) / COUNT(DISTINCT substr(dtcriacao, 0, 11)) AS PontosDia
FROM 
    transacoes
WHERE
    qtdepontos > 0;
*/

--------------------------------------------------------------------------------------------

/*
-- Qual dia da semana tem mais pedidos em 2025?
-- Domingo = 0
SELECT 
    strftime('%w', date(substr(dtcriacao, 0, 11))) AS DiaSemana,
    COUNT(DISTINCT idtransacao) AS ContagemTransacoes
FROM transacoes
WHERE
    dtcriacao > '2024-12-31'
    AND
    dtcriacao < '2026-01-01'
GROUP BY
    DiaSemana
ORDER BY
    ContagemTransacoes DESC
LIMIT 1;
*/

--------------------------------------------------------------------------------------------

/*
-- Qual o produto mais transacionado?
SELECT 
    idproduto,
    COUNT(idtransacao) AS ContagemTransacao
FROM transacao_produto
GROUP BY
    idproduto
ORDER BY
    ContagemTransacao DESC
LIMIT 1;
*/

--------------------------------------------------------------------------------------------

/*
-- Qual o produto com mais pontos transacionado?
SELECT 
    idproduto,
    SUM(vlproduto) AS TotalPontos
FROM transacao_produto
GROUP BY
    idproduto
ORDER BY 
    2 DESC
LIMIT 1;
*/