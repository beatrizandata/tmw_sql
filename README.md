# 📊 SQL Journey: Loyalty System - Téo Me Why

Este repositório contém o progresso e os códigos desenvolvidos durante o curso de SQL da plataforma **Téo Me Why**. 
O projeto foca em manipular dados reais de um sistema de fidelidade, onde usuários ganham e trocam pontos por recompensas durante transmissões ao vivo.

## 📁 Sobre os Dados
Os dados representam o ecossistema de pontos do streamer Téo Calvo, disponíveis no [Kaggle](https://www.kaggle.com/datasets/teocalvo/teomewhy-loyalty-system).
*   **Contexto:** Transações de ganho/gasto de pontos, cadastro de clientes e catálogo de produtos/recompensas.
*   **Período analisado:** Dados históricos com foco especial na semana do curso de SQL (25/08/2025 a 29/08/2025).

## 🛠️ Stack Tecnológica
*   **Engine:** SQLite
*   **Interface:** VS Code (SQLite Extension)

---

## 🚀 Aprendizado Adquirido (Prática)

O curso seguiu uma trilha de complexidade crescente, culminando na criação de uma *Feature Store* para modelagem de dados.

### 1. Fundamentos e Filtros (DML/DQL)
*   Consultas básicas com `SELECT`, `WHERE` e `LIMIT`.
*   Manipulação de strings com `LIKE` (busca por padrões como 'churn%' ou '%Lover').
*   Criação de lógicas condicionais complexas com `CASE WHEN` para categorização de clientes (Pônei, Mago, etc).

### 2. Agregações e Métricas de Negócio
*   Uso de `GROUP BY` e `HAVING` para sumarizar pontos por cliente.
*   Cálculos estatísticos: `SUM`, `AVG`, `MIN`, `MAX` e `COUNT(DISTINCT)`.
*   Tratamento de datas com `strftime` e `julianday` para calcular idade na base e dias entre transações.

### 3. Relacionamentos e Subqueries
*   Modelagem de dados com `LEFT JOIN` e `INNER JOIN` para conectar transações a produtos e perfis de clientes.
*   Uso de **CTEs (Common Table Expressions)** com a cláusula `WITH` para organizar queries complexas e torná-las legíveis.
*   **Subqueries** para filtros dinâmicos (ex: filtrar transações apenas de produtos específicos sem saber o ID previamente).

### 4. Funções de Janela (Window Functions) - O Diferencial
*   `ROW_NUMBER()`: Utilizado para criar rankings de produtos mais consumidos por usuário.
*   `SUM() OVER()`: Para cálculo de faturamento e pontos acumulados ao longo do tempo (soma cumulativa).
*   `LAG()`: Para calcular o intervalo de dias (churn/retenção) entre uma compra e outra.

### 5. Persistência e Engenharia de Dados
*   Criação e manutenção de tabelas: `CREATE TABLE AS`, `INSERT INTO`, `UPDATE` e `DELETE`.
*   Desenvolvimento de uma **Feature Store de Cliente**: Uma tabela analítica consolidando comportamento de 7, 14, 28 e 56 dias (recência, frequência e engajamento).

---

## 📈 Diagnóstico e Insights (Case: Semana de SQL)

Abaixo, os resultados da análise exploratória realizada sobre o comportamento dos alunos durante a semana do curso (25/08 a 29/08/2025):

| Pergunta de Negócio | Resultado |
| :--- | :--- |
| **Alunos no 1º dia (Presença vs. Transação)** | **413** assinaram a lista, mas **452** realizaram alguma interação. |
| **Total de alunos únicos na semana** | **584** clientes diferentes interagiram com o sistema. |
| **Retenção (Stay Rate) do 1º ao 5º dia** | De 452 no início, **207** restaram no último dia (~**45,7%** de retenção). |
| **Média de aulas assistidas** | Em média, cada aluno participou de **3 aulas**. |
| **Dia de maior engajamento** | O **5º dia** foi o ápice de transações por aluno. |

### 🔍 Destaque Analítico: Curva de Churn
Através das queries de `LEFT JOIN` entre o primeiro e o último dia, foi possível identificar a queda gradual de participação, permitindo entender o "drop-off" dos alunos e a aderência ao conteúdo longo.

---

## 🏆 Projeto Final: Feature Store de Cliente
O script `05_pf_aula.sql` consolida o perfil comportamental:
1.  **Saldos:** Pontos positivos, negativos e saldo atual.
2.  **Recência:** Dias desde a última interação.
3.  **Frequência:** Transações em janelas de tempo (D7, D14, D28).
4.  **Preferências:** Produto mais resgatado e período do dia mais ativo (Manhã/Tarde/Noite).
5.  **Engajamento:** Razão entre transações recentes vs. históricas.

---

### Como utilizar este repositório
1.  Certifique-se de ter o [SQLite](https://www.sqlite.org/download.html) instalado ou a extensão no VS Code.
2.  Baixe o dataset no Kaggle e importe o CSV para o seu banco `.db`.
3.  Execute os arquivos na ordem numérica para acompanhar a evolução do aprendizado.

---
👋 Conecte-se comigo!
Estou sempre aberta a trocar ideias sobre SQL, dados e como transformar dados em histórias.

--- 
*Projeto desenvolvido por [Seu Nome] como parte do portfólio de análise de dados.*
