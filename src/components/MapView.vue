<template>
  <div class="map">
    
    {{ msg }}<br>{{ lat }},{{ lng }}
    <button v-on:click="switchLayerSatelliteTraffic">Satellite Traffic</button>
    <button v-on:click="switchLayerNormalTraffic">Normal Traffic</button>
    <button v-on:click="geolocateme">Find me :)</button>
    <button v-on:click="loadgpx">Load GPX</button>
    <div style="width: 100%; height: 480px" id="mapContainer"></div>
  </div>
</template>

<script>
import axios from 'axios';
var H = window.H
var parser = new DOMParser()

export default {
  name: 'MapView',

  data: function () {
    return {
      platform: null,
      map: null,
      behavior: null,
      ui: null,
      defaultLayers: null,
      lat: 51.520763,
      lng: -0.102138,
      msg: "..."
    }
  },
  mounted: function () {
    this.platform = new H.service.Platform({
      'app_id': process.env.VUE_APP_HERE_APP_ID,
      'app_code': process.env.VUE_APP_HERE_APP_CODE
    });
    //this.platform.configure(H.map.render.panorama.RenderEngine)

    var zoom_default =14
    this.defaultLayers = this.platform.createDefaultLayers();
    this.map = new H.Map(
      document.getElementById('mapContainer'),
      this.defaultLayers.normal.map,
      {
        zoom: zoom_default,
        center: { lat: this.lat, lng: this.lng },
        //engineType: H.Map.EngineType.PANORAMA
      }
    );
    this.behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(this.map));
    this.ui = H.ui.UI.createDefault(this.map, this.defaultLayers);

    this.useMetricMeasurements(this.map, this.defaultLayers);

    

  },
  methods: {
    loadgpx: function () {
      this.msg="Load GPX..."
      axios.get('http://localhost:8081/2710885.gpx')
      .then(response => {
        var self = this
        var text = response.data
        console.log(text)
        var parser = new DOMParser()
        var xmlDoc = parser.parseFromString(text,"text/xml")
        var wpts = xmlDoc.getElementsByTagName("trkpt")
        var points=[]
        var point={}
        for (var i = wpts.length - 1; i >= 0; i--) {
           point = { lat: wpts[i].getAttribute("lat"), lng: wpts[i].getAttribute("lon") }
           points.push(point)

        }
        var linestring = new H.geo.LineString();
        points.forEach(function(point) {
          linestring.pushPoint(point);
        });

        // Initialize a polyline with the linestring:
        var polyline = new H.map.Polyline(linestring, { style: { lineWidth: 3 }});

        // Add the polyline to the map:
        this.map.addObject(polyline);

        // Zoom the map to make sure the whole polyline is visible:
        this.map.setViewBounds(polyline.getBounds());

        /*
        parseString(response.data, function (err, result) {
          console.log(result)
          this.msg="Position: "+this.lat+ " "+this.lng
        })
        */        
      })
    
      
    },
    reverseGeocodingSuccess: function (result) {
      var location = result.Response.View[0].Result[0]
      this.msg = location.Location.Address.Label
    },
    reverseGeocoding: function () {
      var reverseGeocodingParameters = {
        prox: ''+this.lat+','+this.lng+',150',
        mode: 'retrieveAddresses',
        maxresults: 1
      }
      var geocoder = this.platform.getGeocodingService()
      geocoder.reverseGeocode(
        reverseGeocodingParameters,
        this.reverseGeocodingSuccess,
        function(e) { this.msg = e });


    },
    updateCenter: function () {
      var coords = {lat: this.lat, lng: this.lng}
      this.map.setCenter(coords)
    },
    geoSetPosition: function (position) {
      console.log(position)
      this.lat = position.coords.latitude
      this.lng = position.coords.longitude
      this.updateCenter()
      this.msg = "Found on: "+this.lat+" "+this.lng
      this.reverseGeocoding()
    },
    geolocateme: function () {
      if (navigator.geolocation) {
          this.msg = "Finding you"
          navigator.geolocation.getCurrentPosition(this.geoSetPosition)

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
