/*
SELECT 
        idproduto,
        count(*)
FROM transacao_produto
GROUP BY idproduto
*/

-- Qual usuário mais juntou pontos no mês de Julho?
SELECT 
    idcliente,
    SUM(qtdepontos) AS SomaPontos,
    COUNT(IdTransacao) AS ContagemdeTransações
FROM
    transacoes
WHERE
    dtcriacao > '2025-07-01'
    AND
    dtcriacao < '2025-08-01'
GROUP BY
    idcliente
HAVING --"Where" do group by
    sum(qtdepontos) >= 4000
ORDER BY
    SomaPontos DESC