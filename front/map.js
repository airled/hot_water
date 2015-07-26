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
	document.getElementById('sidebar').innerHTML = httpGet(String(position));
}

function httpGet(position){
	var url = 'http://maps.googleapis.com/maps/api/geocode/json?latlng=' + String(position).replace('(','').replace(')','').replace(' ','') + '&sensor=true&language=ru';
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    geodata = JSON.parse(xmlHttp.responseText);
    if (String(geodata.results[0].address_components[0].long_name[0].match(/[0-9]/)) == 'null'){
    	alert('Акела промахнулся')
    }
    else{
    	return geodata.results[0].address_components[1].long_name + " " + geodata.results[0].address_components[0].long_name;
    }
}

google.maps.event.addDomListener(window, 'load', initialize);
