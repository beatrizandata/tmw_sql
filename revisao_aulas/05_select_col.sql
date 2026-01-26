SELECT
    idcliente,
    qtdepontos + 10 AS qtdepontosplus10,
    qtdepontos * 2 AS qtdepontosdouble,
    dtcriacao,
    datetime(substr(dtcriacao, 1, 19)) AS datahora,
    strftime('%w', datetime(substr(dtcriacao, 1, 10))) AS diasemana
FROM
    clientes