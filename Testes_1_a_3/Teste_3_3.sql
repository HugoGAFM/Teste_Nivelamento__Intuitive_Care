-- Olá! seja bem vindo(a) ao Exercicio 3.3 e 3.4 de estruturação de tabelas.
-- Esse daqui é um exercício de banco de dados, onde e utilizado os dados CSV da ANS para criar um banco de dados local com as informações utilizando postgres.
-- será necessário fazer a criação das tabelas, que está disponível no dicionário de dados disponibilizado. 
-- Nesse primeiro script a importação da tabelas do relatório CADOP e as importações de dados 
-- Nota: ao fazer uma análise mais de perto do CADOP, percebi que alguns valores podem ser null na tabela, eles são: Complemento, DDD, Telefone, Fax, Regiao_de_Comercializacao e Nome_fantasia, por isso não estão marcados como NOT NULL.
-- Nota 2: também acabei percebendo que na modalidade o valor está errado de varchar no dicionário, o dicionário explicava VARCHAR(2) porém existem muito mais caracteres do que 2, então aumentei para 50.
-- a
CREATE TABLE Operadoras_de_plano_de_saude_com_registro (
    REGISTRO_OPERADORA VARCHAR(6),
    CNPJ VARCHAR(14) NOT NULL,
    Razao_Social VARCHAR(140) NOT NULL,
    Nome_Fantasia VARCHAR(140) NOT NULL,
    Modalidade VARCHAR(50) NOT NULL,
    Logradouro VARCHAR(40) NOT NULL,
    Numero VARCHAR(20) NOT NULL,
    Complemento VARCHAR(40) NULL,
    Bairro VARCHAR(30) NOT NULL,
    Cidade VARCHAR(30) NOT NULL,
    UF VARCHAR(2) NOT NULL,
    CEP VARCHAR(8) NOT NULL,
    DDD VARCHAR(4),
    Telefone VARCHAR(20),
    Fax VARCHAR(20),
    Endereco_eletronico VARCHAR(255) NOT NULL,
    Representante VARCHAR(50) NOT NULL,
    Cargo_Representante VARCHAR(40) NOT NULL,
    Regiao_de_comercializacao smallint CHECK (Regiao_de_comercializacao BETWEEN 1 AND 6),
    Data_Registro_ANS DATE NOT NULL
);
-- Essa daqui é a criação das tabelas, respeitando todas as normas e configurações do dicionário e do arquivo CSV.
-- os campos que não possuem not null é por que podem ser nulos no arquivo CSV.

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.REGISTRO_OPERADORA IS 'Registro de operadora de plano privado de assistência à saúde concedido pela ANS à pessoa jurídica para operação no setor de saúde suplementar';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.CNPJ IS 'CNPJ da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Razao_Social IS 'Razão Social da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Nome_Fantasia IS 'Nome Fantasia da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Modalidade IS 'Classificação das operadoras de planos privados de assistência à saúde de acordo com seu estatuto jurídico.';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Logradouro IS 'Endereço da Sede da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Numero IS 'Numero do Endereço da Sede da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Complemento IS 'Complemento do Endereço da Sede da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Bairro IS 'Bairro do Endereço da Sede da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Cidade IS 'Cidade do Endereço da Sede da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.UF IS 'Estado do Endereço da Sede da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.CEP IS 'CEP do Endereço da Sede da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.DDD IS 'Código de DDD da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Telefone IS 'Número de Telefone da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Fax IS 'Número de Fax da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Endereco_eletronico IS 'E-mail da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Representante IS 'Representante Legal da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Cargo_Representante IS 'Cargo do Representante Legal da Operadora';

COMMENT ON COLUMN Operadoras_de_plano_de_saude_com_registro.Regiao_de_comercializacao IS 'Área onde a operadora de plano privado de assistência à saúde comercializa ou disponibiliza seu plano de saúde, nos termos do Anexo I da Resolução Normativa nº 209/2009, da ANS. 
Região 1: em todo o território nacional ou em grupos de pelo menos três estados dentre os seguintes: São Paulo, Rio de Janeiro, Minas Gerais, Rio Grande do Sul, Paraná e Bahia; 
Região 2: no Estado de São Paulo ou em mais de um estado, excetuando os grupos definidos no critério da região 1; 
Região 3: em um único estado, qualquer que seja ele, excetuando-se o Estado de São Paulo; 
Região 4: no Município de São Paulo, do Rio de Janeiro, de Belo Horizonte, de Porto Alegre ou de Curitiba ou de Brasília; 
Região 5: em grupo de municípios, excetuando os definidos na região 4; e 
Região 6: em um único município, excetuando os definidos na região 4.';

COMMENT ON COLUMN Data_Registro_ANS IS 'Data do Registro da Operadora na ANS (formato AAAA-MM-DD)'; 

-- Essa daqui foi a criação dos comentários do dicionário. vale lembrar que eu utilizei o PostgreSQL para fazer essa parte do Nivelamento, e no postgres, os comentários só podem ser feitos depois de criar os dados nas tabelas.

-- Comando para copiar no psql (ou aqui mesmo dentro do dbeaver) os dados do arquivo CSV que estava no meu diretório de downloads para o banco de dados. 
\COPY Operadoras_de_plano_de_saude_com_registro(REGISTRO_OPERADORA, CNPJ, Razao_Social, Nome_Fantasia, Modalidade, Logradouro, Numero, Complemento, Bairro, Cidade, UF, CEP, DDD, Telefone, Fax, Endereco_eletronico, Representante, Cargo_Representante, Regiao_de_comercializacao, Data_Registro_ANS) FROM 'C:/Users/Hugog/Downloads/Relatorio_cadop.csv' DELIMITER ';' CSV HEADER;