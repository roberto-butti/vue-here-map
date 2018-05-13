<template>
  <div class="map">
    
    {{ msg }}<br>{{ lat }},{{ lng }}
    <button v-on:click="switchLayerSatelliteTraffic">Satellite Traffic</button>
    <button v-on:click="switchLayerNormalTraffic">Normal Traffic</button>
    <button v-on:click="geolocateme">Find me :)</button>
    <div style="width: 100%; height: 480px" id="mapContainer"></div>
  </div>
</template>

<script>
import axios from 'axios';
var H = window.H

export default {
  name: 'MapView',
  props: {
    msg: String
  },
  data: function () {
    return {
      map: null,
      behavior: null,
      ui: null,
      defaultLayers: null,
      lat: 51.520763,
      lng: -0.102138
    }
  },
  mounted: function () {
    var platform = new H.service.Platform({
      'app_id': process.env.VUE_APP_HERE_APP_ID,
      'app_code': process.env.VUE_APP_HERE_APP_CODE
    });
    var zoom_default =14
    this.defaultLayers = platform.createDefaultLayers();
    this.map = new H.Map(
      document.getElementById('mapContainer'),
      this.defaultLayers.normal.map,
      {
        zoom: zoom_default,
        center: { lat: this.lat, lng: this.lng }
      }
    );
    this.behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(this.map));
    this.ui = H.ui.UI.createDefault(this.map, this.defaultLayers);

    this.useMetricMeasurements(this.map, this.defaultLayers);

    

  },
  methods: {
    updateCenter: function () {
      var coords = {lat: this.lat, lng: this.lng}
      this.map.setCenter(coords)
    },
    geoSetPosition: function (position) {
      console.log(position)
      this.lat = position.coords.latitude
      this.lng = position.coords.longitude
      this.updateCenter()
    },
    geolocateme: function () {
      if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(this.geoSetPosition);
      } else { 
          this.msg = "Geolocation is not supported by this browser.";
      }
    },
    switchLayerNormalTraffic: function () {
        this.map.setBaseLayer(this.defaultLayers.normal.traffic)
    },
    switchLayerSatelliteTraffic: function () {
        this.map.setBaseLayer(this.defaultLayers.satellite.traffic)
    },

    useImperialMeasurements: function (map, defaultLayers) {
      var ui = H.ui.UI.createDefault(map, defaultLayers);
      ui.setUnitSystem(H.ui.UnitSystem.IMPERIAL);
    },
    useMetricMeasurements: function (map, defaultLayers) {
      var ui = H.ui.UI.createDefault(map, defaultLayers);
      ui.setUnitSystem(H.ui.UnitSystem.METRIC);
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
