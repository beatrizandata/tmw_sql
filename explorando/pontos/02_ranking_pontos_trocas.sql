-- Usuários que mais ganharam pontos, foram os que mais trocaram seus pontos?

WITH 

tb_trocas AS(
    SELECT 
        idcliente,
        SUM(qtdepontos) AS qtdepontos
    FROM 
        transacoes
    WHERE
        qtdepontos < 0
    GROUP BY
        idcliente
    ORDER BY
        qtdepontos
    LIMIT 10
),

tb_pontos AS(
    SELECT 
        idcliente,
        SUM(qtdepontos) AS qtdepontos
    FROM 
        transacoes
    WHERE
        qtdepontos > 0
    GROUP BY
        idcliente
    ORDER BY
        qtdepontos DESC
    LIMIT 10
)

SELECT 
    t1.*,
    t2.qtdepontos AS qtdetrocados
FROM
    tb_pontos AS t1
LEFT OUTER JOIN
    tb_trocas AS t2
ON 
    t1.idcliente = t2.idcliente

/*
Todos os 9 primeiros colocados no ranking de usuários que mais obtiveram pontos são os mesmos colocados
no ranking de usuários que mais trocaram pontos. Somente o último usuário não teve correspondência
no ranking de troca de pontos, portanto, ele é o único dos 10 que mais receberam pontos que TAMBÉM
mais trocaram pontos.
*/