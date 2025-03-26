<template>
  <div class="container">
    <h2>Buscar Operadoras</h2>

    <!-- Campo para Nome Fantasia -->
    <input
      v-model="termo"
      placeholder="Digite o Nome Fantasia (opcional)"
    />

    <!-- Campo para UF -->
    <select v-model="uf">
      <option value="">Selecione a UF (opcional)</option>
      <option v-for="estado in estados" :key="estado" :value="estado">
        {{ estado }}
      </option>
    </select>

    <!-- Campo para Limite -->
    <input
      type="number"
      v-model="limit"
      placeholder="Digite o limite de resultados"
      min="1"
    />

    <button @click="buscarOperadoras">Buscar</button>

    <transition-group name="fade" tag="ul" class="card-list">
      <li
        v-for="operadora in operadoras"
        :key="operadora.registro_operadora"
        class="card"
      >
        <h3>{{ operadora.nome_fantasia }}</h3>
        <p><strong>Registro:</strong> {{ operadora.registro_operadora }}</p>
        <p><strong>Razão Social:</strong> {{ operadora.razao_social }}</p>
        <p><strong>Cidade:</strong> {{ operadora.cidade }}</p>
        <p><strong>UF:</strong> {{ operadora.uf }}</p>
      </li>
    </transition-group>

  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      termo: "", // Nome Fantasia
      uf: "", // UF selecionada
      limit: 10, // Valor padrão de limite
      operadoras: [],
      estados: [
        "AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS",
        "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC",
        "SP", "SE", "TO",
      ], 
    };
  },
  methods: {
    async buscarOperadoras() {
  try {
    // Cria um objeto com os parâmetros
    const params = {
      limit: this.limit,
    };
    if (this.termo) {
      params.termo = this.termo;
    }
    if (this.uf) {
      params.uf = this.uf;
    }

    // Converte o objeto em uma string de consulta
    const queryString = new URLSearchParams(params).toString();

    // Faz a requisição para o backend
    const response = await axios.get(`http://127.0.0.1:8000/operadoras/busca/?${queryString}`);
    this.operadoras = response.data.operadoras;
    console.log("Resposta da API:", response.data);
  } catch (error) {
    console.error("Erro ao buscar operadoras:", error);
    alert("Erro ao buscar operadoras. Tente novamente.");
  }
},
  },
};
</script>

<style scoped>
.container {
  max-width: 700px;
  margin: auto;
  align-items: center;
  justify-content: center;
  display: flex;
  flex-direction: column;
  text-align: center;
}

input,
select {
  width: 32rem;
  margin-top: 10px;
  margin-bottom: 10px;
  padding: 15px 20px;
  border-radius: 50px;
  border: 1px solid #ddd;
  background-color: #fff;
  font-size: 16px;
  color: #333;
  outline: none;
  appearance: none; /* Remove o estilo padrão do select */
}

select {
  cursor: pointer; /* Mostra o cursor de seleção */
}

.card-list {
  list-style-type: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-wrap: wrap; /* Permite que os itens quebrem para a próxima linha */
  justify-content: center; /* Centraliza os cards na linha */
  gap: 15px; /* Espaçamento entre os cards */
}

h2 {
  margin-bottom: 20px;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.8s ease, transform 0.8s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateX(20px); /* Move os cards para baixo ao aparecer */
}

.fade-leave-from,
.fade-enter-to {
  opacity: 1;
  transform: translateX(0); /* Posição final dos cards */
}

button {
  width: 31rem;
  margin-top: 10px;
  margin-bottom: 10px;
  padding: 10px 20px;
  background-color: #3ce287;
  color: rgb(0, 0, 0);
  border: none;
  border-radius: 100px;
  cursor: pointer;
}

.card {
  font-size: 8px;
  margin-top: 15px;
  background-color: #f9f9f9;
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(35, 77, 212, 0.1);
  text-align: center;
  flex: 1 1 calc(20% - 15px); /* Cada card ocupa 20% da largura menos o espaçamento */
  max-width: calc(20% - 15px); /* Limita a largura máxima de cada card */
  height: 300px; /* Define uma altura fixa para os cards */
  width: 1500px;
  display: flex;
  flex-direction: column;
  justify-content: space-between; /* Distribui o conteúdo uniformemente */
  align-items: center; /* Centraliza o conteúdo horizontalmente */
  overflow: hidden; /* Garante que o conteúdo não ultrapasse os limites do card */
}

.card h3 {
  margin: 0 0 10px;
  font-size: 16px;
  color: #333;
}

.card p {
  margin: 5px 0;
  font-size: 14px;
  color: #555;
}

.card p strong {
  color: #000;
}


</style>
