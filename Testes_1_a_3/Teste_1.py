import os
import requests
from bs4 import BeautifulSoup
from zipfile import ZipFile
from urllib.parse import urljoin



### Olá, Sejá bem vindo(a) a Atividade 01 de nivelamento da Intuitive Care.
### Nesse nivelamento, foi proposto criar um script em Python que faça o download de dois arquivos PDF do site da ANS
### (Agência Nacional de Saúde Suplementar) e os compactar em um arquivo ZIP.
### O script foi desenvolvido em Python, utilizando as bibliotecas requests, BeautifulSoup e zipfile.
### O script foi testado e validado no ambiente de desenvolvimento local, e está funcionando corretamente.

### OBS: Vale lembrar que esses scripts foram feitos especificamente para o exercício que utilizava o site da ANS, e não funcionará em outros sites.
### para isso, seria necessário fornecer uma URL diferente e ajustar o nome dos links de acordo com o site. Mas a lógica é a mesma!

### Vamos para a explicação do código!

### 1. O código é dividido em 3 partes:

# ---------------- PARTE 1 ------------------ #

URL = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos" 

os.makedirs("downloads", exist_ok=True) # 1. Cria a pasta "downloads" se ela não existir.

def baixar_pdf(url, nome_arquivo): # 2. Essa daqui é a função para baixar um PDF, ela utiliza a URL do site e o nome do arquivo como parâmetros.

    resposta = requests.get(url, stream=True)
    if resposta.status_code == 200: # 3. Checa se o site está respondendo corretamente.
        caminho_arquivo = os.path.join("downloads", nome_arquivo)
        with open(caminho_arquivo, "wb") as f:
            for chunk in resposta.iter_content(1024): 
                f.write(chunk) # 4. Escreve o conteúdo desse PDF no arquivo.
        print(f"\n !=== Download concluído: {nome_arquivo} ===!")
        return caminho_arquivo
    else:
        print(f" !=== Erro ao baixar {nome_arquivo} ===!") # 5. Tratamento de erro. Nesse caso, o código dará certo por que estamos fornecendo manualmente o link, mas é importante ter um tratamento de erro para boas práticas de programação.
        return None
    
# ---------------- PARTE 1 ------------------ #

# ---------------- PARTE 2 ------------------ #

resposta = requests.get(URL)
soup = BeautifulSoup(resposta.text, "html.parser") # Aqui utilizamos a biblioteca BeautifulSoup para a leitura e Parsing do HTML da página, para a extração dos links.
# Caso não conheça a biblioteca BeautifulSoup, aqui está a documentação oficial: https://www.crummy.com/software/BeautifulSoup/bs4/doc/

links = soup.find_all("a", href=True) # 6. Encontra todos os links da página.
pdf_links = { "Anexo I": None, "Anexo II": None }

for link in links: # 7. Itera sobre os links encontrados.
    href = urljoin(URL, link["href"]) ## Aqui é utilizada a biblioteca urlLib para juntar a URL base com o link encontrado. caso não conheça a biblioteca, acesse --> https://docs.python.org/3/library/urllib.parse.html
    texto = link.get_text(strip=True)  
    if "Anexo I." in texto: # 8. Verifica se o link é o Anexo I ou Anexo II. a biblioteca BeautifulSoup escaneia todos os links, mas com essa verificação, só é pego os links específicos para o nivelamento.
            pdf_links["Anexo I"] = href
    elif "Anexo II." in texto:
            pdf_links["Anexo II"] = href

print("\n!=== Links encontrados para download ===!")
for nome, link in pdf_links.items(): # 9. Printa no terminal os links de Anexo específicos definidos encontrados.
    print(f"{nome}: {link}")

# ---------------- PARTE 2 ------------------ #

# ---------------- PARTE 3 ------------------ #

arquivos_baixados = []
for nome, link in pdf_links.items(): # 10. Escaneia os Anexos
    if link:
        nome_arquivo = f"{nome}.pdf"
        caminho = baixar_pdf(link, nome_arquivo) 
        if caminho:
            arquivos_baixados.append(caminho) # 11. Adiciona o caminho do arquivo (que no caso é a pasta downloads que foi criada no início) na lista de arquivos baixados.



zip_path = "downloads/anexos.zip"  # 12 utiliza a mesma lógica de Escaneamento para compactar os arquivos baixados em um arquivo ZIP.
with ZipFile(zip_path, "w") as zipf: 
    for arquivo in arquivos_baixados: 
        zipf.write(arquivo, os.path.basename(arquivo))
print(f"\n !=== Arquivos compactados em {zip_path} ===!")


print("\n!=== Fim do programa ===!")

# ---------------- PARTE 3 ------------------ #