/* Regra de Negócio:
    0 a 500         -> Pônei
    501 a 1000      -> Pônei Premium
    1001 a 5000     -> Mago Aprendiz
    5001 a 10000    -> Mago Mestre
    + 10001         -> Mago Supremo
*/

   SELECT
        idcliente,
        qtdepontos,
        CASE 
            WHEN qtdepontos <= 500 THEN 'Pônei'
            WHEN qtdepontos <= 1000 THEN 'Pônei Premium'
            WHEN qtdepontos <= 5000 THEN 'Mago Aprendiz'
            WHEN qtdepontos <= 10000 THEN 'Mago Mestre'
            WHEN qtdepontos > 10000 THEN 'Mago Supremo'
        END AS categoriacliente,
        CASE
            WHEN qtdepontos <= 500 THEN 1 ELSE 0 END AS flponei,
        CASE
            WHEN qtdepontos >= 501 AND qtdepontos <= 1000 THEN 1 ELSE 0 END AS flponeipremium,
        CASE
            WHEN qtdepontos >= 1001 AND qtdepontos <= 5000 THEN 1 ELSE 0 END AS flmagoaprendiz,
        CASE
            WHEN qtdepontos >= 5001 AND qtdepontos <=10000 THEN 1 ELSE 0 END AS flmagomestre,
        CASE
            WHEN qtdepontos > 10000 THEN 1 ELSE 0 END AS flmagosupremo
    FROM
        clientes
    ORDER BY
        qtdepontos;

WITH 

tb_pontos AS(
    SELECT
        idcliente,
        qtdepontos,
        CASE 
            WHEN qtdepontos <= 500 THEN 'Pônei'
            WHEN qtdepontos <= 1000 THEN 'Pônei Premium'
            WHEN qtdepontos <= 5000 THEN 'Mago Aprendiz'
            WHEN qtdepontos <= 10000 THEN 'Mago Mestre'
            WHEN qtdepontos > 10001 THEN 'Mago Supremo'
        END AS categoriacliente
    FROM
        clientes
    ORDER BY
        qtdepontos
)

-- Contagem de quantos clientes existem por categoria
SELECT 
    COUNT(idcliente) AS contagemcliente,
    categoriacliente
FROM 
    tb_pontos
GROUP BY
    categoriacliente
ORDER BY
    contagemcliente DESC