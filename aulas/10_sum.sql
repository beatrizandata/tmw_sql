SELECT
    SUM(qtdepontos) AS Operacao,

    SUM(CASE 
        WHEN qtdepontos > 0 THEN qtdePontos
        END) AS qtdepontosPositivos,

    SUM(CASE 
        WHEN qtdepontos < 0 THEN qtdePontos
        END) AS qtdepontosNegativos
        
FROM
    transacoes

WHERE 
    dtcriacao >= '2025-07-01'
    AND
    dtcriacao < '2025-08-01'
    