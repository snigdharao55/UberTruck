<!DOCTYPE html>
<html>
  <head>
    <title>Uber Truck</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <style>
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #map {
        height: 70%;
      }
.controls {
  margin-top: 10px;
  border: 1px solid transparent;
  border-radius: 2px 0 0 2px;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  height: 32px;
  outline: none;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
}

#origin-input,
#destination-input {
  background-color: #fff;
  font-family: Roboto;
  font-size: 15px;
  font-weight: 300;
  margin-left: 12px;
  padding: 0 11px 0 13px;
  text-overflow: ellipsis;
  width: 350px;
}

#origin-input:focus,
#destination-input:focus {
  border-color: #4d90fe;
}

#mode-selector {
  color: #fff;
  background-color: #4d90fe;
  margin-left: 12px;
  padding: 5px 11px 0px 11px;
}

#mode-selector label {
  font-family: Roboto;
  font-size: 13px;
  font-weight: 300;
}
#right-panel1 {
  font-family: 'Roboto','sans-serif';
  line-height: 30px;
  padding-left: 10px;
  }
  
  #right-panel1 {
        height: 30%;
        float: bottom;
        width: 100%;
        overflow: auto;
  }


    </style>
    
     <script type="text/javascript" >
    function initMaps(origin1,destinationA) {
      var bounds = new google.maps.LatLngBounds;

    


      var service = new google.maps.DistanceMatrixService;
      service.getDistanceMatrix({
        origins : [ origin1 ],
        destinations : [ destinationA ],
        travelMode : google.maps.TravelMode.DRIVING,
        unitSystem : google.maps.UnitSystem.IMPERIAL,
        avoidHighways : false,
        avoidTolls : false
      }, function(response, status) {
        if (status !== google.maps.DistanceMatrixStatus.OK) {
          alert('Error was: ' + status);
        } else {
          var originList = response.originAddresses;
          var destinationList = response.destinationAddresses;
          var outputDiv = document.getElementById('right-panel1');
          outputDiv.innerHTML = '';

          for (var i = 0; i < originList.length; i++) {
            var results = response.rows[i].elements;

            for (var j = 0; j < results.length; j++) {

              var dist = results[j].distance;
              var time = results[j].duration;
              var d_dist = (dist.value)/(1600*4);
              var final = ((dist.value)/1600)*2.5;
              var d_time= (time.value)/(60*4);
              outputDiv.innerHTML +=  '<br>'+'Pick Up Location:      '+' ' +originList[i]  + '<br>'+'Drop Off Location:     '
                  + destinationList[j] + ' ' +'<br>' + ' Distance: '
                  + results[j].distance.text +'<br>' +'   '+  ' Time: '
                  + results[j].duration.text + ',   ' + 'Estimated Fare $' + final.toFixed(2) + '<br>'
                  +'Driver arriving in '+d_time.toFixed(2)+' mins'+ '<br>'+'Driver distance from Pick up: '+d_dist.toFixed(2)+' mi';
            }
          }
        }
      });
    }</script>
  </head>
  <body>
    <input id="origin-input" class="controls" type="text"
        placeholder="Enter an origin location">

    <input id="destination-input" class="controls" type="text"
        placeholder="Enter a destination location">


    <div id="map"></div>
    
    
<div id="right-panel1"></div>
    <script>
function initMap() {
  var origin_place_id = null;
  var destination_place_id = null;
  var travel_mode = google.maps.TravelMode.WALKING;
  var map = new google.maps.Map(document.getElementById('map'), {
    mapTypeControl: false,
    center: {lat: 38.8688, lng: -100.2195},
    zoom: 5
  });
  var directionsService = new google.maps.DirectionsService;
  var directionsDisplay = new google.maps.DirectionsRenderer;
  directionsDisplay.setMap(map);
  var lat=new Array();
  var lon=new Array();

  xmlhttp = new XMLHttpRequest();

  xmlhttp.open("GET", "markers.xml", false);

      xmlhttp.send();

      xmlDoc = xmlhttp.responseXML;

    var a=xmlDoc.getElementsByTagName("location");

    var l=a.length;


  var l1=33.860090, l2=-118.286755;
  var myLatLng = {lat: l1, lng: l2};
  i=0;
  do{
    lon=xmlDoc.getElementsByTagName("lat")[i].childNodes[0].nodeValue;
    lat=xmlDoc.getElementsByTagName("long")[i].childNodes[0].nodeValue;
  var location = new google.maps.LatLng(lat, lon);     
          marker = new google.maps.Marker({
              position: location,
              map: map,
              icon:"car.png",
              
    title:xmlDoc.getElementsByTagName("id")[i].childNodes[0].nodeValue +":"+ xmlDoc.getElementsByTagName("name")[i].childNodes[0].nodeValue
          }); 
  i++;
  }while(i<l)
    
  

  var origin_input = document.getElementById('origin-input');
  var destination_input = document.getElementById('destination-input');
  var modes = document.getElementById('mode-selector');

  map.controls[google.maps.ControlPosition.TOP_LEFT].push(origin_input);
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(destination_input);
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(modes);

  var origin_autocomplete = new google.maps.places.Autocomplete(origin_input);
  origin_autocomplete.bindTo('bounds', map);
  var destination_autocomplete =
      new google.maps.places.Autocomplete(destination_input);
  destination_autocomplete.bindTo('bounds', map);

  // Sets a listener on a radio button to change the filter type on Places
  // Autocomplete.
  function setupClickListener(id, mode) {
    var radioButton = document.getElementById(id);
    radioButton.addEventListener('click', function() {
      travel_mode = mode;
    });
  }

  function expandViewportToFitPlace(map, place) {
    if (place.geometry.viewport) {
      map.fitBounds(place.geometry.viewport);
    } else {
      map.setCenter(place.geometry.location);
      map.setZoom(17);
    }
  }

  origin_autocomplete.addListener('place_changed', function() {
    var place = origin_autocomplete.getPlace();
    if (!place.geometry) {
      window.alert("Autocomplete's returned place contains no geometry");
      return;
    }
    expandViewportToFitPlace(map, place);

    // If the place has a geometry, store its place ID and route if we have
    // the other place ID
    origin_place_id = place.place_id;
    route(origin_place_id, destination_place_id, travel_mode,
          directionsService, directionsDisplay);
  });

  destination_autocomplete.addListener('place_changed', function() {
    var place = destination_autocomplete.getPlace();
    if (!place.geometry) {
      window.alert("Autocomplete's returned place contains no geometry");
      return;
    }
    expandViewportToFitPlace(map, place);

    // If the place has a geometry, store its place ID and route if we have
    // the other place ID
    destination_place_id = place.place_id;
    route(origin_place_id, destination_place_id, travel_mode,
          directionsService, directionsDisplay);
  });

  function route(origin_place_id, destination_place_id, travel_mode,
                 directionsService, directionsDisplay) {
    if (!origin_place_id || !destination_place_id) {
      return;
    }
    directionsService.route({
      origin: {'placeId': origin_place_id},
      destination: {'placeId': destination_place_id},
      travelMode: travel_mode
    }, function(response, status) {
      if (status === google.maps.DirectionsStatus.OK) {
        directionsDisplay.setDirections(response);
        var pick_l=document.getElementById('origin-input').value;
        var drop_l=document.getElementById('destination-input').value;
        initMaps(pick_l , drop_l);
      } else {
        window.alert('Directions request failed due to ' + status);
      }
    });
  }
}

    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA5LozyI2W5fYllW1Yn0veBN8yFMzmhB2o&signed_in=true&libraries=places&callback=initMap"
        async defer></script>
  </body>
</html>