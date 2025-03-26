from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware 
import psycopg2

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # Permitir apenas o frontend
    allow_credentials=True,
    allow_methods=["*"],  # Permitir todos os métodos (GET, POST, etc.)
    allow_headers=["*"],  # Permitir todos os cabeçalhos
)

# 🔗 Função para conectar ao banco de dados
def get_connection():
    return psycopg2.connect(
        host='localhost',
        database='teste_nivelamento',
        user='dev',
        password='dev',
    )



@app.get("/operadoras/busca/")
def buscar_operadoras(
    termo: str = Query(None),
    uf: str = Query(None, max_length=2),  # UF é opcional e deve ter no máximo 2 caracteres
    limit: int = Query(10, gt=0)  # Apenas impede números negativos ou zero
):
    connection = get_connection()
    cursor = connection.cursor()

    # Base da query
    query = """
        SELECT REGISTRO_OPERADORA, Nome_Fantasia, Razao_Social, Cidade, UF
        FROM Operadoras_de_plano_de_saude_com_registro
    """
    conditions = []
    params = []

    # Adiciona condições dinamicamente
    if termo:
        conditions.append("Nome_Fantasia ILIKE %s")
        params.append(f"%{termo}%")
    if uf:
        conditions.append("UF = %s")
        params.append(uf)

    # Adiciona as condições à query, se existirem
    if conditions:
        query += " WHERE " + " AND ".join(conditions)

    # Ordena e limita os resultados
    query += " ORDER BY Nome_Fantasia ASC LIMIT %s"
    params.append(limit)

    # Executa a query
    cursor.execute(query, params)
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
        {"registro": op[0], "nome_fantasia": op[1], "razao_social": op[2], "cidade": op[3], "uf": op[4]}
        for op in operadoras
    ]}