<template>
  <v-navigation-drawer
    v-model="drawer"
    app
    clipped
  >
  <v-list >
    <v-list-tile v-for="item in items" :key="item.text"   >
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
</template>

<script>


var H = window.H


export default {
  name: 'NavigationDrawer',

  data: function () {
    return {
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

    }
  },
  created: function () {
    this.$root.$on('manage_drawer', this.manage_drawer)
  },
  methods: {
    manage_drawer: function () {
      this.drawer = ! this.drawer
    }
  }
}
</script>
