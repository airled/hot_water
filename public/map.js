var markers = [];

function initialize(){
	var mapOptions = {
		center: {lat: 53.9, lng: 27.55}, 
		zoom: 11,
		zoomControl: true,
		zoomControlOptions: {
			style: google.maps.ZoomControlStyle.SMALL
		}
	};
	var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	google.maps.event.addListener(map, 'click', function(point) {
		placeMarker(point.latLng, map);
	});
}

function placeMarker(position, map){
	if (markers.length > 0) {
		for (var i = 0; i < markers.length; i++ ) {
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

function getAddressWithDate(position){
	var url = 'http://maps.googleapis.com/maps/api/geocode/json?latlng=' + String(position).replace(/[\(\) ]/g,'') + '&sensor=true&language=ru';
	geodata = JSON.parse(request(url));
	var street = geodata.results[0].address_components[1].long_name.replace('улица','').trim();
	var house = geodata.results[0].address_components[0].long_name;
	if(String(house[0].match(/[0-9]/)) == 'null'){
		return 'Неточный адрес';
	}
	else{
		return street + ', ' + house + '<br>' + getDate(street,house);
	}
}

google.maps.event.addDomListener(window, 'load', initialize);
