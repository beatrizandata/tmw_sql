-- Top 10 clientes com mais pontos
SELECT *
FROM 
    clientes
ORDER BY 
    QtdePontos DESC
LIMIT 10;

-- Retorna os clientes mais antigos da base
SELECT 
    idcliente,
    substr(dtcriacao, 0,11) AS data
FROM 
    clientes
WHERE
    data = '2024-02-01'
ORDER BY
    dtcriacao;

-- Retorna os clientes conectados a Twitch por ordem ascendente de dtcriacao (mais antigos primeiro) + qtdepontos (os que tem maior pontuação primeiro)
SELECT 
    idcliente,
    fltwitch,
    qtdepontos,
    date(substr(dtcriacao, 0, 11)) AS datacriacao
FROM
    clientes
WHERE
    fltwitch = 1
ORDER BY
    datacriacao ASC, qtdepontos DESC;