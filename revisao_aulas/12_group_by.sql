SELECT
    idproduto, 
    count(*)
FROM
    transacao_produto
GROUP BY
    idproduto;

-- Qual usuário mais juntou pontos no mês de Julho/2025?
SELECT
    idcliente,
    SUM(qtdepontos) AS contagempontos,
    substr(dtcriacao, 0, 11) AS data
FROM
    clientes
WHERE
    dtcriacao < '2025-08-01'
    AND
    dtcriacao >= '2025-07-01'
GROUP BY
    idcliente
ORDER BY
    contagempontos DESC
LIMIT
    1;


