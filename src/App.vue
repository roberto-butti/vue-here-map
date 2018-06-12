<template>
  <v-app>

    <NavigationDrawer />

    <v-toolbar

      dense
      fixed
      clipped-left
      app
    >
      <v-toolbar-side-icon @click.stop="$root.$emit('manage_drawer')"></v-toolbar-side-icon>

      <v-toolbar-title class="mr-5 align-center">
        <span class="title"><img class="logo" src="./assets/logo.png">UE HERE MAPS</span>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-layout row align-center style="max-width: 650px">
        <v-text-field
          :append-icon-cb="() => {}"
          placeholder="Search..."
          single-line
          append-icon="search"
          color="white"
          hide-details
        ></v-text-field>
      </v-layout>
    </v-toolbar>

    <v-content>
      <v-container fluid >

        <MapView ref="map_view" />

      </v-container>
    </v-content>
    <v-footer app>

      <strong>Vue.js -HERE Maps</strong>, an experiment for using Vue.js and HERE Maps.
      Github repository: <a href="https://github.com/roberto-butti/vue-here-map">https://github.com/roberto-butti/vue-here-map</a>

    </v-footer>
  </v-app>



</template>

<script>

import MapView from './components/MapView.vue'
import NavigationDrawer from './components/NavigationDrawer.vue'
var vm = window.vm

export default {
  name: 'app',
  data: () => ({
    }),
  components: {
    MapView, NavigationDrawer

  }
}
</script>

<style>
img.logo {
  width: 32px;
}
</style>
