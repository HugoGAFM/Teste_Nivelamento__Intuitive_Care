<script setup>
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <div>
    
    <nav>
      <ul>
        <li><router-link to="/"></router-link></li>
      </ul>
    </nav>

    
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App',
}
</script>

<style>

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
