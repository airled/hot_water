function initialize() {
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
	var marker = new google.maps.Marker({
		position: position,
		map: map,
		title: String(position)
	});
	// var infowindow = new google.maps.InfoWindow({
	//     content: address,
	//     size: new google.maps.Size(150, 50)
 //    });

	// google.maps.event.addListener(marker, 'click', function() {
	// 	infowindow.open(map,marker);
	// });
	// console.log(position);
	document.getElementById('sidebar').innerHTML = getAddress(String(position));
}

function getAddress(position){
	var url = 'http://maps.googleapis.com/maps/api/geocode/json?latlng=' + String(position).replace(/[\(\) ]/g,''); + '&sensor=true&language=ru';
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open("GET", url, false);
	xmlHttp.send(null);
	geodata = JSON.parse(xmlHttp.responseText);
	var street = geodata.results[0].address_components[1].long_name.replace('улица','').trim();
	var house = geodata.results[0].address_components[0].long_name;
	if(String(house[0].match(/[0-9]/)) == 'null'){
		return '//Промах//';
	}
	else{
		return getDate(street,house);
	}
}

function getDate(street,house){
	var url = 'http://localhost:4567/date?street=' + String(street) + '&house=' + String(house);
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open("GET", url, false);
	xmlHttp.send(null);
	return (JSON.parse(xmlHttp.responseText).date + '<br>' + street + ', ' + house);
}

google.maps.event.addDomListener(window, 'load', initialize);
