-- Usuários mais antigos, são os que ganharam mais pontos?


-- Para cálculo de idade do usuário, foi usado a data da primeira transação!
WITH 

clientes_antigos AS(
    SELECT
        idcliente,
        MIN(substr(dtcriacao, 0, 11)) AS dtcriacao,
        julianday('2026-01-26') - julianday(MIN(substr(dtcriacao, 0, 11))) AS idade
    FROM
        transacoes
    GROUP BY
        idcliente
    ORDER BY
        idade DESC
),

clientes_pontos AS(
    SELECT
        idcliente,
        SUM(CASE WHEN qtdepontos >= 0 THEN qtdepontos END) AS pontospositivos,
        MIN(dtcriacao) AS dtcriacao
    FROM
        transacoes
    GROUP BY
        idcliente
    ORDER BY
        pontospositivos DESC
    LIMIT 10
),

idade_maxima AS(
    SELECT
        MIN(substr(dtcriacao, 0, 11)) AS dtminima,
        julianday('2026-01-26') - julianday(MIN(substr(dtcriacao, 0, 11))) AS idademaxima
    FROM 
        transacoes
)


SELECT
    t1.idcliente,
    t1.pontospositivos,
    t2.dtcriacao,
    t2.idade,
    t3.idademaxima,
    idademaxima - idade AS diff,
    (CASE WHEN idademaxima - idade <= 30 THEN 'primeiro mes'
    WHEN idademaxima - idade <= 60 THEN 'segundo mes'
    WHEN idademaxima - idade <= 90 THEN 'terceiro mes'
    WHEN idademaxima - idade <= 120 THEN 'quarto mes' 
    WHEN idademaxima - idade <= 150 THEN 'quinto mes' END) AS categoriaidade
FROM
    clientes_pontos AS t1
LEFT JOIN
    clientes_antigos AS t2
ON
    t1.idcliente = t2.idcliente
CROSS JOIN -- Possibilita que o cálculo seja replicado em cada linha da tabela
    idade_maxima AS t3
ORDER BY
    diff;

