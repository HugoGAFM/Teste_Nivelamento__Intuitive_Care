<script setup>
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <div>
    <!-- A navegação pode ser adicionada aqui -->
    <nav>
      <ul>
        <li><router-link to="/"></router-link></li>
      </ul>
    </nav>

    <!-- Este é o ponto onde o conteúdo das páginas será carregado conforme a rota -->
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App',
}
</script>

<style>
/* Estilos globais */
h1 {
  text-align: center;
}



ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline;
  margin-right: 10px;
}
</style>
