import os
import pandas as pd
import zipfile
import pdfplumber

# Olá! seja bem vindo(a) ao meu Teste de Nivelamento da Intuitive Care.
# Esse daqui é o segundo exercício, onde foi proposto criar um script em Python que extraia as tabelas da atividade anterior de PDF para CSV.
# O script foi desenvolvido em Python, utilizando as bibliotecas pandas, zipfile e pdfplumber.
# O script foi testado e validado no ambiente de desenvolvimento local, e está funcionando corretamente.
# Recomendo (caso não conheça) utilizar as extensões vscode-pdf e CSV para visualizar os arquivos gerados diretamente no VS Code.

### Vamos para a explicação do código!

def transformate(pdf_path, csv_path, zip_path): # essa função é responsável por extrair as tabelas do PDF e salvar em um arquivo CSV, e depois compactar em um arquivo ZIP.
    
    with pdfplumber.open(pdf_path) as pdf: # O pdfplumber escaneia o PDF em procura de tabelas.
        data = [] # variável para armazenamento das tabelas.
        for page in pdf.pages:
            table = page.extract_table() # Extrai a tabela da página.
            if table:
                data.extend(table)  # Adiciona a tabela na variável data.

    
    df = pd.DataFrame(data[1:], columns=data[0])  # Criação de um DataFrame.

    
    column_mapping = { # Mapeia as colunas OD e AMB para os nomes que foi requerido no nivelamento.
        "OD": "Seg. Odontológico",
        "AMB": "Seg. Ambulatorial"
    }
    df.rename(columns=column_mapping, inplace=True) # Renomeia essas colunas.

    df.to_csv(csv_path, index=False) # Agora sim salva esse dataframe que foi criado anteriormente.

    
    with zipfile.ZipFile(zip_path, 'w') as zipf:
        zipf.write(csv_path, os.path.basename(csv_path)) # Transforma o arquivo CSV em um arquivo ZIP.




pdf_file = "downloads/Anexo I.pdf" # Caminho do arquivo PDF
csv_file = "downloads/Anexo_I.csv" # Caminho do arquivo CSV
zip_file = "downloads/Teste_HugoGabriel.zip" # Caminho do arquivo ZIP

# Executar a função
transformate(pdf_file, csv_file, zip_file) # Executa a função que foi criada acima. 

print(f"\n !=== Arquivo {csv_file} criado com sucesso! ===!")
print(f"!=== Arquivo {zip_file} criado com sucesso! ===!\n")