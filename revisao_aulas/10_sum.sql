SELECT
    SUM(qtdepontos) AS operacao,
    SUM(
        CASE WHEN qtdepontos> 0 THEN qtdepontos END) AS qtdepontospositivos,
    SUM(
        CASE WHEN qtdepontos < 0 THEN qtdepontos END) AS qtdepontosnegativos
FROM
    transacoes
WHERE
    dtcriacao >= '2025-07-01'
    AND
    dtcriacao < '2025-08-01';


SELECT
    SUM(CASE
            WHEN qtdepontos <= 500 THEN 1 ELSE 0 END) AS flponei,
    SUM(CASE
            WHEN qtdepontos >= 501 AND qtdepontos <= 1000 THEN 1 ELSE 0 END) AS flponeipremium,
    SUM(CASE
            WHEN qtdepontos >= 1001 AND qtdepontos <= 5000 THEN 1 ELSE 0 END) AS flmagoaprendiz,
    SUM(CASE
            WHEN qtdepontos >= 5001 AND qtdepontos <=10000 THEN 1 ELSE 0 END) AS flmagomestre,
    SUM(CASE
            WHEN qtdepontos > 10000 THEN 1 ELSE 0 END )AS flmagosupremo
FROM
    clientes;