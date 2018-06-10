<template>
  <div>
    <v-app>
      <v-navigation-drawer
      fixed
      clipped
      v-model="drawer"
      app
    >

      <v-list dense>
        <v-list-tile v-for="item in items" :key="item.text" >
          <v-list-tile-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>

            <v-list-tile-title @click="$root.$emit(item.function_handler)">
              {{ item.text }}
            </v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
      </v-list>

    </v-navigation-drawer>
    <v-toolbar

      dense
      fixed
      clipped-left
      app
    >
      <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>

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
        <v-container fluid><MapView ref="map_view" /></v-container>
      </v-content>
      <v-footer app>
      
        <strong>Vue.js -HERE Maps</strong>, an experiment for using Vue.js and HERE Maps.
        Github repository: <a href="https://github.com/roberto-butti/vue-here-map">https://github.com/roberto-butti/vue-here-map</a>
      
      </v-footer>
    </v-app>



  </div>
</template>

<script>

import MapView from './components/MapView.vue'
var vm = window.vm

export default {
  name: 'app',
  data: () => ({
      drawer: false,
      items: [
        { icon: 'trending_up', text: 'Satellite Traffic', function_handler: 'switchLayerSatelliteTraffic' },
        { icon: 'traffic', text: 'Normal Traffic', function_handler: 'switchLayerNormalTraffic' },
        {
          icon: 'location_city',
          text: 'Find me',
          function_handler: 'geolocateme'
        },
        {
          icon: 'motorcycle',
          text: 'Follow me',
          function_handler: 'followPosition'
        },
        {
          icon: 'stop',
          text: 'Stop to Follow me',
          function_handler: 'stopFollow'
        },
        {
          icon: 'cloud_upload',
          text: 'GPX loader',
          function_handler: 'loadgpx'
        },

      ],
    }),
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
