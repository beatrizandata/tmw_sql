-- Tabela de clientes que estiveram no último mês e suas transações (Ciclo completo)

CREATE TABLE  IF NOT EXISTS clientes_d28 (
    idcliente VARCHAR(250) PRIMARY KEY,
    qtdetransacoes INT
);

DELETE FROM clientes_d28;

INSERT INTO clientes_d28
SELECT 
    idcliente,
    COUNT(DISTINCT idtransacao) AS qtdetransacoes
FROM 
    transacoes
WHERE
    julianday('now') - julianday(substr(dtcriacao, 1, 10)) <= 28
GROUP BY
    idcliente;

SELECT * FROM clientes_d28;
