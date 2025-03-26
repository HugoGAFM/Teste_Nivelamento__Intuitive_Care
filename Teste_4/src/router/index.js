import { createRouter, createWebHistory } from 'vue-router'

import OperadoraSearch from '../components/OperadoraSearch.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: OperadoraSearch,
    },
  ],
})

export default router
