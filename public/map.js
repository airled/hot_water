var markers = [];

function initialize(){
	var currentZoom;
	
	if(window.innerHeight < 500){
		currentZoom = 11;
	}
	else if(window.innerHeight > 1200){
		currentZoom = 13;
	}
	else{
		currentZoom = 12;
	}

	var mapOptions = {
		center: {lat: 53.9, lng: 27.55}, 
		zoom: currentZoom,
		disableDefaultUI: true
	};

	var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	google.maps.event.addListener(map, 'click', function(point) {
		placeMarker(point.latLng, map);
	});
	// console.log(window.innerWidth, window.innerHeight);
	// console.log(mapOptions.zoom);
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
	document.getElementById('panel').style.opacity = "1";
	setResult(getAddressWithDate(String(position)));
}

google.maps.event.addDomListener(window, 'load', initialize);
