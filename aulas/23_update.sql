SELECT *
FROM 
    relatorio_diario;

-- Troca TODOS os dados
UPDATE relatorio_diario
SET contagem = 10000
WHERE dtdia >= '2025-08-25';

SELECT * FROM relatorio_diario