var markers = [];

function initialize(){
	var mapOptions = {
		center: {lat: 53.9, lng: 27.55}, 
		zoom: 11,
		disableDefaultUI: true
	};
	var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	google.maps.event.addListener(map, 'click', function(point) {
		placeMarker(point.latLng, map);
	});
}

function placeMarker(position, map){
	if (markers.length > 0) {
		for (var i = 0; i < markers.length; i++){
	    	markers[i].setMap(null);
	    }
	}
	document.getElementById('sidebar').innerHTML = '';	
	var marker = new google.maps.Marker({
		position: position,
		map: map,
		title: String(position)
	});
	markers.push(marker);
	document.getElementById('sidebar').innerHTML = getAddressWithDate(String(position));
}

google.maps.event.addDomListener(window, 'load', initialize);
