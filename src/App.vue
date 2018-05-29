<template>
  <div>
    <img class="logo" src="./assets/logo.png">
    <MapView  />
    <footer class="footer">
  <div class="container">
    <div class="content has-text-centered">
      <p>
        <strong>Vue.js -HERE Maps</strong>, an experiment for using Vue.js and HERE Maps.<br>
        Github repository: <a href="https://github.com/roberto-butti/vue-here-map">https://github.com/roberto-butti/vue-here-map</a>
      </p>
    </div>
  </div>
</footer>
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
