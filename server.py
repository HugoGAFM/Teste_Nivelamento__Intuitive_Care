import os
from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
import psycopg2
from urllib.parse import urlparse

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://relatoriosdocadop-o0dudla7q-hugogafms-projects.vercel.app"],
    allow_credentials=True,
    allow_methods=["*"],  # Permitir todos os métodos 
    allow_headers=["*"],  # Permitir todos os cabeçalhos
)


def get_connection():  # Função para conectar ao banco de dados
    # Pega a URL de conexão do banco de dados do Railway
    database_url = os.getenv('DATABASE_URL')

    # Usa urllib.parse para fazer o parse da URL de conexão
    url = urlparse(database_url)

    return psycopg2.connect(
        host=url.hostname,
        database=url.path[1:],  # Remove o primeiro '/' da URL
        user=url.username,
        password=url.password,
        port=url.port
    )


@app.get("/operadoras/busca/")
def buscar_operadoras(
    termo: str = Query(None),
    uf: str = Query(None, max_length=2),  # UF é opcional e deve ter no máximo 2 caracteres
    limit: int = Query(10, gt=0)  # Apenas impede números negativos ou zero
):
    connection = get_connection()
    cursor = connection.cursor()

    query = """
        SELECT REGISTRO_OPERADORA, Nome_Fantasia, Razao_Social, Cidade, UF
        FROM Operadoras_de_plano_de_saude_com_registro
    """
    conditions = []
    params = []

    if termo:  # Adiciona condições dinamicamente
        conditions.append("Nome_Fantasia ILIKE %s")
        params.append(f"%{termo}%")
    if uf:
        conditions.append("UF = %s")
        params.append(uf)

    if conditions:  # Adiciona as condições à query, se existirem
        query += " WHERE " + " AND ".join(conditions)

    query += " ORDER BY Nome_Fantasia ASC LIMIT %s"  # Ordena e limita os resultados
    params.append(limit)

    cursor.execute(query, params)  # Executa a query
    operadoras = cursor.fetchall()

    cursor.close()
    connection.close()

    return {
        "operadoras": [
            {
                "registro_operadora": op[0],
                "nome_fantasia": op[1],
                "razao_social": op[2],
                "cidade": op[3],
                "uf": op[4],
            }
            for op in operadoras
        ]
    }


@app.get("/operadoras/todas/")
def listar_todas_operadoras():
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("SELECT REGISTRO_OPERADORA, Nome_Fantasia, Razao_Social, Cidade, UF FROM Operadoras_de_plano_de_saude_com_registro")
    operadoras = cursor.fetchall()

    cursor.close()
    connection.close()

    return {"operadoras": [
        { "registro": op[0],
          "nome_fantasia": op[1], 
          "razao_social": op[2], 
          "cidade": op[3], 
          "uf": op[4]}
        for op in operadoras
    ]}
