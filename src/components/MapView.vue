<template>
  <div class="map">


    <div style="width: 100%; height: 480px; z-index=auto" id="mapContainer"></div>
    <v-bottom-sheet v-model="show_info">
      <v-card tile>
        <table class="table is-narrow">
          <tbody>
            <tr><th>Lat</th><td>{{ lat }}</td></tr>
            <tr><th>Lng</th><td>{{ lng }}</td></tr>
            <tr><th>Accuracy</th><td>{{ accuracy }}</td></tr>
            <tr><th>Altitude</th><td>{{ altitude }}</td></tr>
            <tr><th>Altitude Accuracy</th><td>{{ altitudeAccuracy }}</td></tr>
            <tr><th>Speed</th><td>{{ speed   }} {{ speed * 3.6   }} km/h</td></tr>
            <tr><th>Heading</th><td>{{ heading }}</td></tr>
          </tbody>
        </table>
      </v-card>
    </v-bottom-sheet>
    <v-btn
      fab
      bottom
      right
      color="pink"
      dark

      @click.stop="followPosition"
    >

      <v-icon v-if="!loading_followme">search</v-icon>
      <v-progress-circular  v-if="loading_followme" indeterminate color="primary"></v-progress-circular>
    </v-btn>
    <v-btn
      fab
      bottom
      right
      color="pink"
      dark

      @click.stop="geolocateme"
    >

      <v-icon v-if="!loading">room</v-icon>
      <v-progress-circular  v-if="loading" indeterminate color="primary"></v-progress-circular>
    </v-btn>
    <div>{{ msg }}</div>

  </div>
</template>

<script>
import axios from 'axios'
import moment from 'moment'

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
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      speed: 0,
      heading: 0,
      msg: "...",
      idWatch: false,
      marker: null,
      dialog: false,
      show_info: false,
      loading: false,
      loading_followme:false,
      fab: true
    }
  },

created: function () {
    this.$root.$on('switchLayerSatelliteTraffic', this.switchLayerSatelliteTraffic)
    this.$root.$on('switchLayerNormalTraffic', this.switchLayerNormalTraffic)
    this.$root.$on('geolocateme', this.geolocateme)
    this.$root.$on('followPosition', this.followPosition)
    this.$root.$on('stopFollow', this.stopFollow)
    this.$root.$on('loadgpx', this.loadgpx)
    this.$root.$on('showInfo', this.showInfo)
  },

mounted: function () {
    this.platform = new H.service.Platform({
      'app_id': process.env.VUE_APP_HERE_APP_ID,
      'app_code': process.env.VUE_APP_HERE_APP_CODE,
      'useHTTPS': true
    });
    //this.platform.configure(H.map.render.panorama.RenderEngine)
    var zoom_default =14
    // if you need to customize the BaseLayer:
    // https://developer.here.com/documentation/maps/topics/map-types.html
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


    //this.map.getViewPort().resize();

  },
  methods: {

    showInfo: function () {
      console.log("Show INfo")
      this.show_info = true
    },
    focus_map: function () {
      console.log("Focus map");
      this.map.getViewPort().resize();
    },

    getDistanceFromLatLonInKm: function (lat1,lon1,lat2,lon2) {
      var R = 6371 // Radius of the earth in km
      var dLat = this.deg2rad(lat2-lat1)  // deg2rad below
      var dLon = this.deg2rad(lon2-lon1)
      var a =
        Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(this.deg2rad(lat1)) * Math.cos(this.deg2rad(lat2)) *
        Math.sin(dLon/2) * Math.sin(dLon/2)
        ;
      var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      var d = R * c // Distance in km
      return d;
    },

    deg2rad: function (deg) {
      return deg * (Math.PI/180)
    },


    loadgpx: function () {
      this.msg="Load GPX..."
      axios.get('/sample.gpx')
      .then(response => {
        var self = this
        var text = response.data
        //console.log(text)
        var parser = new DOMParser()
        var xmlDoc = parser.parseFromString(text,"text/xml")
        var wpts = xmlDoc.getElementsByTagName("trkpt")
        var points=[]
        var point={}
        var lat=0.0
        var lon = 0.0
        var s0=0
        var s1=0
        var max_speed = {lat:0.0, lng:0.0, speed:0}
        for (var i = 0; i< wpts.length ; i++) {
          lat = wpts[i].getAttribute("lat")
          lon = wpts[i].getAttribute("lon")
          var time = wpts[i].getElementsByTagName("time")[0].childNodes[0].nodeValue
          s0 = s1
          s1 = moment(time)
          //console.log(s1)
          var distance = 0
          var interval = 0
          if (i>0) {
            distance = this.getDistanceFromLatLonInKm(lat, lon, wpts[i-1].getAttribute("lat"), wpts[i-1].getAttribute("lon"))
          }
          var hours = (s1.diff(s0)/1000) / 3600
          var speed = distance / hours
          if (speed > max_speed.speed) {
            max_speed.speed = speed
            max_speed.lat = lat
            max_speed.lng = lon
          }
          //console.log("Speed:"+ speed + " km/h")

          point = { lat: lat, lng: lon , distance: distance, time: s1.diff(s0)/1000, s0: s0, s1: s1}


           points.push(point)

        }

        //console.log(points)
        var linestring = new H.geo.LineString();
        points.forEach(function(point) {
          linestring.pushPoint(point);
        });

        // Initialize a polyline with the linestring:
        var polyline = new H.map.Polyline(linestring, { style: { lineWidth: 3 }});

        // Add the polyline to the map:
        this.map.addObject(polyline);
        var max_speed_coords = {lat: max_speed.lat, lng: max_speed.lng}
        var max_speed_marker = new H.map.Marker(max_speed_coords)
        this.map.addObject(max_speed_marker)

        var bubble  =  new H.ui.InfoBubble(max_speed_coords, {content : "Max Speed:"+Math.round(max_speed.speed*100)/100+" Km/h"});
        this.ui.addBubble(bubble);
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

      if (this.marker == null) {
        var svgMarkup = '<svg width="24" height="24" ' +
          'xmlns="http://www.w3.org/2000/svg">' +
          '<rect stroke="white" fill="#1b468d" x="1" y="1" width="22" ' +
          'height="22" /><text x="12" y="18" font-size="12pt" ' +
          'font-family="Arial" font-weight="bold" text-anchor="middle" ' +
          'fill="white">V</text></svg>';
        var icon = new H.map.Icon(svgMarkup);
        this.marker = new H.map.Marker(coords, {icon: icon});
        this.map.addObject(this.marker);

      } else {
        this.marker.setPosition(coords)
      }
    },

    geoSetPosition: function (position, wantReverse = true) {
      console.log(position)
      this.lat = position.coords.latitude
      this.lng = position.coords.longitude
      this.accuracy = position.coords.accuracy
      this.altitude = position.coords.altitude
      this.altitudeAccuracy = position.coords.altitudeAccuracy
      this.speed = position.coords.speed
      this.heading = position.coords.heading

      this.switchLayerSatelliteTraffic()
      this.map.setZoom(18);
      this.updateCenter()
      this.msg = "Found on: "+this.lat+" "+this.lng
      if (wantReverse) {
        this.reverseGeocoding()
      }
      this.loading=false

    },

    geoWatchPosition: function (position) {
      this.geoSetPosition(position, false)
      this.loading_followme=false
    },

    errorCurrentPosition: function (err) {
      var strError = 'ERROR('+err.code+'): '+err.message
      console.log(strError)
      this.msg =strError
      this.loading=false
      this.loading_followme=false
    },
    geolocateme: function () {
      if (navigator.geolocation) {
          this.msg = "Finding you"
          var options = {
            enableHighAccuracy: true,
            timeout: 5000,
            maximumAge: 0
          }
          this.loading = true
          navigator.geolocation.getCurrentPosition(this.geoSetPosition, this.errorCurrentPosition, options)

      } else {
          this.msg = "Geolocation is not supported by this browser.";
      }
      this.map.getViewPort().resize();
    },

    followPosition: function () {
      this.msg ="implementing Follow Me function"
      if (navigator.geolocation) {
          this.msg = "I will follow you"
          var options = {
            enableHighAccuracy: true,
            timeout: 5000,
            maximumAge: 0
          }
          this.loading_followme=true
          this.idWatch = navigator.geolocation.watchPosition(this.geoWatchPosition, this.errorCurrentPosition, options)
          console.log(this.idWatch)

      } else {
          this.msg = "Geolocation is not supported by this browser.";
      }
    },

    stopFollow: function () {
      if (this.idWatch) {
        navigator.geolocation.clearWatch(this.idWatch)
        this.idWatch = false
      }

    },

    switchLayerNormalTraffic: function () {
        this.map.setBaseLayer(this.defaultLayers.normal.traffic)
    },
    switchLayerSatelliteTraffic: function () {
      console.log("switchLayerSatelliteTraffic")
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


</style>
