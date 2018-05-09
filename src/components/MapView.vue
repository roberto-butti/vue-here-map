<template>
  <div class="map">
    
    {{ msg }}<br>
    <button v-on:click="switchLayerTraffic">Traffic</button>

    <div style="width: 100%; height: 480px" id="mapContainer"></div>
  </div>
</template>

<script>

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
      defaultLayers: null
    }
  },
  mounted: function () {
    var platform = new H.service.Platform({
      'app_id': process.env.VUE_APP_HERE_APP_ID,
      'app_code': process.env.VUE_APP_HERE_APP_CODE
    });
    var lat_default = 51.520763
    var lng_default = -0.102138
    var zoom_default =14
    this.defaultLayers = platform.createDefaultLayers();
    this.map = new H.Map(
      document.getElementById('mapContainer'),
      this.defaultLayers.normal.map,
      {
        zoom: zoom_default,
        center: { lat: lat_default, lng: lng_default }
      }
    );
    this.behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(this.map));
    this.ui = H.ui.UI.createDefault(this.map, this.defaultLayers);

    this.useMetricMeasurements(this.map, this.defaultLayers);

    

  },
  methods: {
    switchLayerTraffic: function () {
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
