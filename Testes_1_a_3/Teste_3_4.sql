-- Nesse teste foi proposto fazer a migração de dados específicos de operadoras para dentro do banco de dados, depois fazer Queries de busca.
-- Para esse teste eu utilizei o DBeaver, PostgreSQL, pgAdmin e o psql.
--  a

-- Criação de Banco de Dados --

CREATE TABLE dados_financeiros_anual_2023_2024 ( --criação da tabela

data DATE NOT NULL,
reg_ans VARCHAR(10) NOT NULL,
cd_conta_contabil VARCHAR(20) NOT NULL,
descricao TEXT NOT NULL,
vl_saldo_inicial NUMERIC(15,2) NOT NULL,
vl_saldo_final NUMERIC(15,2) NOT NULL

);

CREATE TABLE dados_importacao ( 
    data TEXT,                  -- caso fosse tentado importar os dados diretamente no banco de dados final, o comando daria erro de importação.
    reg_ans TEXT,               -- Minha abordagem para a formatação de dados foi criar uma tabela intermediária que consistia em pegar todos os dados, em formato de texto.
    cd_conta_contabil TEXT,     -- Depois de pegar todos esses dados, o que eu fiz foi apenas formatá-los do jeito correto com o insert.
    descricao TEXT,
    vl_saldo_inicial TEXT,
    vl_saldo_final TEXT
);

-- Esse daqui é o insert que faz a intermediação dos dados pra tabela final
INSERT INTO dados_financeiros_anual_2023_2024 (data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
SELECT 
    CASE 
        WHEN data ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(data, 'YYYY-MM-DD') -- esse case foi necessário pois os dados a partir de 2023-10-01 invertem, indo para o formato DD/MM/YYYY
        WHEN data ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(data, 'DD/MM/YYYY') -- aqui ele checa cada dado e os coloca corretamente.
        ELSE NULL
    END,
    reg_ans,
    cd_conta_contabil,
    descricao,
    REPLACE(vl_saldo_inicial, ',', '.')::NUMERIC(15,2), -- Registrando os números corretamente com as suas decimais.
    REPLACE(vl_saldo_final, ',', '.')::NUMERIC(15,2)
FROM dados_importacao;

-- Fazendo as importações dos dados na tabela intermediária para depois inseri-lás na tabela final com o insert.
\COPY dados_importacao FROM 'C:\Users\Hugog\Downloads\Teste de Nivelamento\downloads\1T2023.csv' DELIMITER ';' CSV HEADER;
\COPY dados_importacao FROM 'C:\Users\Hugog\Downloads\Teste de Nivelamento\downloads\2T2023.csv' DELIMITER ';' CSV HEADER;
\COPY dados_importacao FROM 'C:\Users\Hugog\Downloads\Teste de Nivelamento\downloads\3T2023.csv' DELIMITER ';' CSV HEADER;
\COPY dados_importacao FROM 'C:\Users\Hugog\Downloads\Teste de Nivelamento\downloads\4T2023.csv' DELIMITER ';' CSV HEADER;
\COPY dados_importacao FROM 'C:\Users\Hugog\Downloads\Teste de Nivelamento\downloads\1T2024.csv' DELIMITER ';' CSV HEADER;
\COPY dados_importacao FROM 'C:\Users\Hugog\Downloads\Teste de Nivelamento\downloads\2T2024.csv' DELIMITER ';' CSV HEADER;
\COPY dados_importacao FROM 'C:\Users\Hugog\Downloads\Teste de Nivelamento\downloads\3T2024.csv' DELIMITER ';' CSV HEADER;
\COPY dados_importacao FROM 'C:\Users\Hugog\Downloads\Teste de Nivelamento\downloads\4T2024.csv' DELIMITER ';' CSV HEADER;

-- Criação de Banco de Dados --

-- Teste de Nivelamento de Queries, questão 3.5 --

-- 3.5.1: Quais as 10 operadoras com maiores despesas em "EVENTOS/ SINISTROS CONHECIDOS OU
-- AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre?
SELECT 
    reg_ans AS operadora,
    descricao,
    SUM(vl_saldo_inicial - vl_saldo_final) AS total_despesas -- faz a comparação total das despesas de uma Operadora
FROM dados_financeiros_anual_2023_2024
WHERE 
    descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR ' -- Procura especificamente o caso da descrição
    AND data > '2024-09-30' -- Pega a partir de 2024-10-01 
GROUP BY reg_ans, descricao
ORDER BY total_despesas desc -- o desc é muito importante, como estamos comparando o saldo inicial vs o saldo final, valores positivos significam a maior despesa, e valores negativos significam lucro.
                             -- sem esse desc, os dados poderiam ser facilmente confundidos com o lucro.
LIMIT 10; --limite de apenas 10 operadoras.


-- 3.5.2: Quais as 10 operadoras com maiores despesas nessa categoria no último ano?
SELECT 
    reg_ans AS operadora,
    descricao,
    SUM(vl_saldo_inicial - vl_saldo_final) AS total_despesas -- mesma lógica anterior.
FROM dados_financeiros_anual_2023_2024
WHERE 
    data > '2023-12-31' -- Pega a partir de 01/01/2024
GROUP BY reg_ans, descricao
ORDER BY total_despesas desc -- mesma lógica anterior.
LIMIT 10; --limite de apenas 10 operadoras.

-- comandos de drop table para caso algo desse errado.
-- drop table dados_financeiros_anual_2023_2024;
-- drop table dados_importacao;