-- Usuários com mais transações, são os que ganharam mais pontos?

WITH 

clientes_pontos AS(
    SELECT
        idcliente,
        SUM(CASE WHEN qtdepontos > 0 THEN qtdepontos END) as pontospositivos
    FROM
        transacoes
    GROUP BY
        idcliente
    ORDER BY
        pontospositivos DESC
    LIMIT 10
),

clientes_transacoes AS(
    SELECT
        idcliente,
        COUNT(idtransacao) as qtdetransacoes
    FROM
        transacoes
    GROUP BY
        idcliente 
    ORDER BY
        qtdetransacoes DESC
    LIMIT 10
)

SELECT
    t1.*,
    t2.qtdetransacoes,
    (CASE WHEN qtdetransacoes > 0 THEN ROW_NUMBER() OVER (ORDER BY t2.qtdetransacoes DESC) ELSE 'fora do ranking' END) AS rankingtransacoes
FROM
    clientes_pontos AS t1
LEFT JOIN
    clientes_transacoes AS t2
ON
    t1.idcliente = t2.idcliente
ORDER BY
    pontospositivos DESC
