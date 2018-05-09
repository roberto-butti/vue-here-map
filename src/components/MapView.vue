<template>
  <div class="map">
    
    {{ msg }}<br>

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
  mounted: function () {
    var platform = new H.service.Platform({
      'app_id': process.env.VUE_APP_HERE_APP_ID,
      'app_code': process.env.VUE_APP_HERE_APP_CODE
    });
    var lat_default = 51.520763
    var lng_default = -0.102138
    var zoom_default =14
    var defaultLayers = platform.createDefaultLayers();
    var map = new H.Map(
      document.getElementById('mapContainer'),
      defaultLayers.normal.map,
      {
        zoom: zoom_default,
        center: { lat: lat_default, lng: lng_default }
      }
    );
    var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(map));
    var ui = H.ui.UI.createDefault(map, defaultLayers);

    this.useMetricMeasurements(map, defaultLayers);

    

  },
  methods: {
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
