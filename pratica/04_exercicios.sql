-- Quais clientes mais perderam pontos por Lover?
/*
SELECT 
    t1.idcliente,
    SUM(t1.qtdepontos) AS PontosPerdidos

FROM
    transacoes as t1 -- Dica: começar sempre a partir da tabela transacional ou fato

LEFT JOIN
    transacao_produto as t2
    ON
    t1.idtransacao = t2.idtransacao

LEFT JOIN
    produtos as t3
    ON
    t2.idproduto = t3.idproduto 

WHERE 
    t3.desccategoriaproduto = 'lovers'

GROUP BY 
    t1.idcliente 

ORDER BY
    PontosPerdidos ASC

LIMIT 10;
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
-- Quais clientes assinaram a lista de presença no dia 2025/08/25? (1° dia de curso)
SELECT
    DISTINCT(t2.idcliente),
    substr(t2.dtcriacao, 0,11) AS Data,
    t3.descnomeproduto

FROM 
    transacao_produto AS t1

LEFT JOIN
    transacoes AS t2
    ON
    t1.idtransacao = t2.idtransacao

LEFT JOIN 
    produtos AS t3
    ON
    t1.idproduto = t3.idproduto

WHERE
    Data = '2025-08-25'
    AND
    t3.descnomeproduto = 'Lista de presença';
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
-- Do início ao fim do nosso curso (2025/08/25 a 2025/08/29), quantos clientes assinaram a lista de presença?
SELECT
    COUNT(DISTINCT(t2.idcliente)),
    t3.descnomeproduto

FROM 
    transacao_produto AS t1

LEFT JOIN
    transacoes AS t2
    ON
    t1.idtransacao = t2.idtransacao

LEFT JOIN 
    produtos AS t3
    ON
    t1.idproduto = t3.idproduto

WHERE
    substr(t2.dtcriacao, 0,11) >= '2025-08-25'
    AND
    substr(t2.dtcriacao, 0,11) < '2025-08-30'
    AND
    t3.descnomeproduto = 'Lista de presença';
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
-- Clientes mais antigos, tem mais frequência de transação?
SELECT
    t1.idcliente,
    CAST(julianday('2026-01-08') - julianday(substr(t1.dtcriacao, 1, 11)) AS INT) AS IdadeCliente,
    COUNT(t2.idtransacao) AS ContagemTransacao
FROM
    clientes as t1
LEFT JOIN
    transacoes as t2
    ON
    t1.idcliente = t2.idcliente
GROUP BY
    t1.idcliente
ORDER BY
    IdadeCliente DESC; -- Restante da análise pelo gráfico plotado em 04_grafico.py, em resposta,
                       -- não podemos afirmar que quanto maior a idade do cliente, mais frequente ele é.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
-- Quantidade de transações Acumuladas ao longo do tempo?
WITH 

tb_transacoes AS(
    SELECT 
        substr(dtcriacao, 0, 11) AS dtdia,
        COUNT(DISTINCT idtransacao) AS contagem
    FROM 
        transacoes
    GROUP BY 
        dtdia
    ORDER BY
        dtdia
),

tb_acumulada AS (
SELECT *,
    SUM(contagem) OVER (ORDER BY dtdia) AS acumulado
FROM
    tb_transacoes
)

SELECT *
FROM
    tb_acumulada;

/*
-- Qual dia atingimos 100.000 transações?
SELECT
    dtdia,
    acumulado
FROM
    tb_acumulada
WHERE
    acumulado > 100000
LIMIT 1;
*/


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Quantidade de usuários cadastrados (absoluto e acumulado) ao longo do tempo?
/*
WITH tb_cadastros AS(
    SELECT
        substr(dtcriacao, 0, 11) AS datacadastro,
        COUNT(DISTINCT idcliente) AS cadastrados
    FROM
        clientes
    GROUP BY
        datacadastro
    ORDER BY
        datacadastro ASC
)

SELECT *,
    SUM(cadastrados) OVER (ORDER BY datacadastro) AS acumulado
FROM
    tb_cadastros;
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
-- Qual o dia da semana mais ativo de cada usuário?

WITH 

tb_transacoes AS(
    SELECT
        idcliente,
        COUNT(DISTINCT idtransacao) as transacoes,
        strftime('%w', (substr(dtcriacao, 0, 11))) as diasemana
    FROM
        transacoes
    GROUP BY
        idcliente, diasemana
    ORDER BY
        idcliente, diasemana
),

tb_rn AS(
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY transacoes DESC) AS rn
    FROM 
        tb_transacoes
)

SELECT 
    *
FROM 
    tb_rn
WHERE
    rn = 1;
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
-- Saldo de pontos acumulado de cada usuário

WITH

tb_pontos AS(
    SELECT 
        idcliente,
        substr(dtcriacao, 0, 11) AS dt,
        SUM(qtdepontos) AS pontos
    FROM
        transacoes
    GROUP BY
        idcliente, dt
    ORDER BY
        idcliente, dt
),

tb_acumulado AS(
    SELECT *,
        SUM(pontos) OVER (PARTITION BY idcliente ORDER BY dt) AS acumulado
    FROM 
        tb_pontos
),

-- Qual dia cada usuário chegou ao seu máximo de pontos acumulados?
tb_ranking AS(
SELECT *,
    ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY acumulado DESC) AS ranking
FROM 
    tb_acumulado
)

SELECT 
    idcliente,
    dt,
    acumulado
FROM 
    tb_ranking
WHERE
    ranking = 1
ORDER BY
    dt;

-- Pergunta interessante: quem tinha a maior quantidade de pontos acumulados em cada dia?
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Dos clientes que começaram SQL no primeiro dia, quantos chegaram ao 5o dia?
/*
Com subquerie:

SELECT 
    COUNT(DISTINCT idcliente)
FROM
    transacoes as t1
WHERE
    t1.idcliente IN (
        SELECT DISTINCT idcliente
        FROM transacoes
        WHERE substr(dtcriacao, 0, 11) = '2025-08-25'
    )
AND
    substr(dtcriacao, 0, 11) = '2025-08-29';

----

Com CTE:

WITH tb_cliente_primeiro_dia AS (
    SELECT DISTINCT idcliente AS idcliente1
    FROM transacoes
    WHERE substr(dtcriacao, 0, 11) = '2025-08-25'
),

tb_cliente_ultimo_dia AS (
    SELECT DISTINCT idcliente AS idcliente2
    FROM transacoes
    WHERE substr(dtcriacao, 0, 11) = '2025-08-29'
),

tb_join AS (
    SELECT *
    FROM
        tb_cliente_primeiro_dia AS t1
    LEFT JOIN
        tb_cliente_ultimo_dia AS t2
    ON
        t1.idcliente1 = t2.idcliente2
)

SELECT 
    COUNT(idcliente1),
    COUNT(idcliente2),
    1. * COUNT(idcliente2) / COUNT(idcliente1)
FROM
    tb_join

*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
-- Como foi a curva de Churn do Curso de SQL?

WITH clientes_prim_dia AS(
    SELECT
        DISTINCT idcliente AS clientes_prim_dia
    FROM
        transacoes
    WHERE
        substr(dtcriacao, 0, 11) = '2025-08-25'
),

transacoes_curso AS(
    SELECT 
        idtransacao,
        idcliente,
        substr(dtcriacao, 0, 11) AS data
    FROM
        transacoes
    WHERE
        substr(dtcriacao, 0, 11) >= '2025-08-25'
        AND
        substr(dtcriacao, 0, 11) < '2025-08-30'
),

tb_join AS(
    SELECT
        t1.clientes_prim_dia,
        t2.data AS datadia
    FROM
        clientes_prim_dia AS t1
    LEFT JOIN
        transacoes_curso AS t2
    ON
        t1.clientes_prim_dia = t2.idcliente
)

SELECT 
    COUNT(DISTINCT clientes_prim_dia) AS Alunos,
    datadia,
    1. * COUNT(DISTINCT clientes_prim_dia) / (SELECT COUNT(*) FROM clientes_prim_dia) AS Proporcao
FROM 
    tb_join
GROUP BY
    datadia;
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
-- Quem iniciou o curso no primeiro dia, em média assistiu quantas aulas?

-- quem participou da 1° aula
WITH tb_primeiro_dia AS(
    SELECT 
        DISTINCT idcliente
    FROM
        transacoes
    WHERE
        substr(dtcriacao, 0, 11) = '2025-08-25'
),

-- todos os participantes de todos os dias de curso
tb_dias_curso AS( 
    SELECT 
        DISTINCT idcliente,
        substr(dtcriacao, 0, 11) AS diapresente
    FROM
        transacoes
    WHERE
        substr(dtcriacao, 0, 11) >= '2025-08-25'
        AND
        substr(dtcriacao, 0, 11) < '2025-08-30'
),

-- quantos usuários do 1° dia voltaram nos outros dias de curso
tb_join AS (
    SELECT
        t1.idcliente,
        COUNT(DISTINCT t2.diapresente) as qtdedias
    FROM
        tb_primeiro_dia AS t1
    LEFT JOIN
        tb_dias_curso AS t2
    ON
        t1.idcliente = t2.idcliente
    GROUP BY
        t1.idcliente
)

-- calculando a média de aulas que os alunos do primeiro dia assistiram
SELECT 
    ROUND(avg(qtdedias), 0)
FROM tb_join;
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
-- Dentre os clientes de janeiro/2025, quantos assistiram o curso de SQL?
-- (Jeito "direto")

WITH tb_clientes_janeiro AS (
    SELECT 
        DISTINCT idcliente
    FROM 
        transacoes
    WHERE
        substr(dtcriacao, 0, 11) >= '2025-01-01'
        AND
        substr(dtcriacao, 0, 11) < '2025-02-01'
)


SELECT
    COUNT(DISTINCT t2.idcliente) AS clientes_janeiro,
    COUNT(DISTINCT t1.idcliente) AS clientes_janeiro_sql
FROM
    tb_clientes_janeiro AS t1
LEFT JOIN
    transacoes AS t2
ON
    t1.idcliente = t2.idcliente
    AND
    substr(t2.dtcriacao, 0, 11) >= '2025-08-25'
    AND
    substr(t2.dtcriacao, 0, 11) < '2025-08-30';

OU

-- (Jeito mais "intuitivo")
WITH tb_clientes_janeiro AS (
    SELECT 
        DISTINCT idcliente
    FROM 
        transacoes
    WHERE
        substr(dtcriacao, 0, 11) >= '2025-01-01'
        AND
        substr(dtcriacao, 0, 11) < '2025-02-01'
),

tb_clientes_sql AS (
    SELECT 
        DISTINCT idcliente
    FROM 
        transacoes
    WHERE
        substr(dtcriacao, 0, 11) >= '2025-08-25'
        AND
        substr(dtcriacao, 0, 11) < '2025-08-30'
)

SELECT
    COUNT(t1.idcliente) AS clientes_janeiro,
    COUNT(t2.idcliente) AS clientes_janeiro_sql
FROM
    tb_clientes_janeiro AS t1
LEFT JOIN
    tb_clientes_sql as t2
ON 
    t1.idcliente = t2.idcliente;

*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
-- Qual o dia com maior engajamento (mais transações) de cada aluno que iniciou o curso no dia 01? (Minha resolução sem WF)


-- Seleciona os alunos que estiveram presentes no primeiro dia
WITH alunos_prim_dia AS (
    SELECT 
        DISTINCT idcliente AS alunos_prim_dia
    FROM
        transacoes
    WHERE
        substr(dtcriacao, 0, 11) = '2025-08-25'
),

-- Seleciona todas as transações registradas nos dias de curso
transacoes_dias_curso AS(
    SELECT
        idtransacao,
        idCliente,
        dtcriacao
    FROM
        transacoes
    WHERE
        substr(dtcriacao, 0, 11) >= '2025-08-25'
        AND
        substr(dtcriacao, 0, 11) < '2025-08-30'    
),

-- Busca quais transações são de alunos do primeiro dia
tb_join AS (
    SELECT 
        t1.alunos_prim_dia,
        t2.idtransacao,
        t2.dtcriacao
    FROM
        alunos_prim_dia AS t1
    LEFT JOIN
        transacoes_dias_curso AS t2
    ON
    t1.alunos_prim_dia = t2.idcliente
),

-- Conta as transações por dia dos alunos do primeiro dia
tb_final AS(
SELECT 
    alunos_prim_dia,
    COUNT(idtransacao) AS transacoes,
    substr(dtcriacao, 0, 11) AS data
FROM 
    tb_join
GROUP BY
    alunos_prim_dia, substr(dtcriacao, 0, 11)
)

-- Exibe o máximo número de transações e o dia em que ocorreram por aluno
SELECT 
    alunos_prim_dia,
    MAX(transacoes),
    data
FROM 
    tb_final
GROUP BY
    alunos_prim_dia;
*/