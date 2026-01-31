-- Voltando ao exercício: Lista de transações com o produto "Resgatar Ponei" 
-- anteriormente foi resolvido olhando manualmente qual era o idproduto

-- Para encontrar o idproduto foi feito:
/*
SELECT 
    idproduto
FROM 
    produtos
WHERE 
    descnomeproduto = 'Resgatar Ponei'
*/

-- Isso pode ser usado como condição dentro de:
/*
SELECT
    *
FROM 
    transacao_produto AS t1
WHERE t1.idproduto IN 
    (
    SELECT idproduto
    FROM produtos
    WHERE descnomeproduto = 'Resgatar Ponei'
    ); -- A primeira query a ser executada é essa
*/
-- Subqueries podem ser bem custosas computacionalmente


-- Dos clientes que começaram SQL no primeiro dia, quantos chegaram ao 5o dia?
/*
SELECT 
    COUNT(DISTINCT idcliente)
FROM
    transacoes as t1
WHERE
    t1.idcliente IN (
        SELECT DISTINCT idcliente
        FROM transacoes
        WHERE substr(dtcriacao, 0, 11) = '2025-08-25'
    )
AND
    substr(dtcriacao, 0, 11) = '2025-08-29';
*/