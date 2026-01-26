SELECT
    SUM(qtdepontos) AS qtdepontos,
    COUNT(idcliente) AS idcliente,
    SUM(qtdepontos)/COUNT(idcliente) AS mediapontoscliente,
    AVG(qtdepontos) AS mediapontos,
    ROUND(AVG(qtdepontos), 2) AS mediaarredondada,
    MIN(qtdepontos) AS minpontos,
    MAX(qtdepontos) AS maxpontos,
    SUM(fltwitch) AS twitch,
    SUM(flemail) AS email
FROM
    clientes