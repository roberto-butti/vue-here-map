<template>
  <div>
    <v-app>
      <v-navigation-drawer app></v-navigation-drawer>
      <v-toolbar app><img class="logo" src="./assets/logo.png"></v-toolbar>
      <v-content>
        <v-container><MapView  /></v-container>
      </v-content>
      <v-footer app>
        <p>
        <strong>Vue.js -HERE Maps</strong>, an experiment for using Vue.js and HERE Maps.<br>
        Github repository: <a href="https://github.com/roberto-butti/vue-here-map">https://github.com/roberto-butti/vue-here-map</a>
      </p>
      </v-footer>
    </v-app>



  </div>
</template>

<script>

import MapView from './components/MapView.vue'

export default {
  name: 'app',
  components: {
    MapView
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
img.logo {
  width: 32px;
}
</style>
