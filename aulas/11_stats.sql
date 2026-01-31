SELECT 
    SUM(qtdepontos),
    COUNT(idcliente),
    SUM(qtdepontos)/COUNT(idcliente) AS MediaPontos,
    AVG(qtdepontos) AS MediaDireta,
    ROUND(AVG(qtdepontos), 2) AS MediaArrendonda,
    MIN(qtdepontos) AS MinPontos,
    MAX(qtdepontos) AS MaxPontos,
    SUM(flTwitch) AS Twitch,
    SUM(flemail) AS Email
FROM clientes
