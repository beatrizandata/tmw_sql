-- Contagem de novos clientes no mês de Julho/2025
SELECT
    COUNT(DISTINCT idcliente)
FROM
    transacoes
WHERE
    dtcriacao >= '2025-07-01'
    AND
    dtcriacao >= '2025-08-01'