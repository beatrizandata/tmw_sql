/*
SELECT *
FROM CLIENTES
ORDER BY QtdePontos DESC
LIMIT 10;
*/

/*
SELECT *
FROM clientes
ORDER BY DtCriacao
*/

-- Por data de criação (ascendente) e por de pontos (descendente)
SELECT *
FROM clientes
WHERE flTwitch = 1
ORDER BY DtCriacao ASC, qtdePontos DESC