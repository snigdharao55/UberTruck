<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding= "ISO-8859-1"%> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Style.css" />    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>UBER</title>

<script src="https://maps.googleapis.com/maps/api/js">
</script>
<script type="text/javascript">
function init() {
    var mapCanvas = document.getElementById('map');
    var mapChoice = {
      center: new google.maps.LatLng(44.5403, -78.5463),
      zoom: 8,
      mapTypeId: google.maps.MapTypeId.TERRAIN
    }
    var map = new google.maps.Map(mapCanvas, mapChoice)
  }
  google.maps.event.addDomListener(window, 'load', init)
</script>
</head>
<h1>UBER</h1>
<body>
<div id="map"></div>
</body>
</html>