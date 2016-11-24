<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

q<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Assignment</title>

    <style>

      html, body {

        height: 100%;

        margin: 0;

        padding: 0;

      } 

      #map {
        height: 100%;
      }
    </style>
</head>

  <body>
    <div id="map"></div>
    <script>



function initMap() {


xml = new XMLHttpRequest();

xml.open("GET", "places.xml", false);

    xml.send();
    xmlDoc = xml.responseXML;
 	var a=xmlDoc.getElementsByTagName("location");
  var l=a.length;
var myLatLng = {lat: 38.100663, lng: -98.130325};

  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 4,
    center: myLatLng
  });

for(i=0; i<l; i++){

longitude=xmlDoc.getElementsByTagName("longitude")[i].childNodes[0].nodeValue;

latitude=xmlDoc.getElementsByTagName("latitude")[i].childNodes[0].nodeValue;

var place = new google.maps.LatLng(latitude, longitude);     

        marker = new google.maps.Marker({

            position: place,

            map: map,

 	title: "location"
        }); 
}
}

    </script>

   <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCeYaq5UJQYOGq1gnA-KgFXCFixDwNIgIM&libraries=places&callback=initAutocomplete"></script>
  </body>

</html>