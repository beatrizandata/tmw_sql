/* INTERVALOS:
0 a 500         -> Pônei
501 a 1000      -> Pônei Premium
1001 a 5000     -> Mago Aprendiz
5001 a 10000    -> Mago Mestre
+10001          -> Mago Supremo
*/

SELECT idCliente,
       QtdePontos,
       CASE
            WHEN qtdepontos <= 500 THEN 'Pônei'
            WHEN qtdepontos <= 1000 THEN 'Pônei Premium'
            WHEN qtdepontos <= 5000 THEN 'Mago Aprendiz'
            WHEN qtdepontos <= 10000 THEN 'Mago Mestre'
            ELSE 'Mago Supremo'
       END AS NomeGrupo,
       CASE
            WHEN qtdepontos <= 1000 THEN 1
            ELSE 0
        END AS flPonei
FROM clientes
ORDER BY qtdepontos ASC

