function request(url){
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open("GET", url, false);
	xmlHttp.send(null);
	return xmlHttp.responseText;
}

function encode(string){
	return encodeURIComponent(string);
}

function getDate(street,house){
	var url = 'http://hotwater.muzenza.by/date?street=' + encode(street) + '&house=' + encode(house);
	// var url = 'http://localhost:4567/date?street=' + encode(street) + '&house=' + encode(house);
	// var url = 'http://localhost:3000/date?street=' + encode(street) + '&house=' + encode(house);
	return (JSON.parse(request(url)).date);
}

function getAddressWithDate(position){
	var url = 'http://maps.googleapis.com/maps/api/geocode/json?latlng=' + String(position).replace(/[\(\) ]/g,'') + '&sensor=true&language=ru';
	geodata = JSON.parse(request(url));
	var street = geodata.results[0].address_components[1].long_name;
	var house = geodata.results[0].address_components[0].long_name;
	if(String(house[0].match(/[0-9]/)) == 'null'){
		return 'Неточный адрес';
	}
	else{
		return street + ', ' + house + '<br>' + 'Отключение: ' + getDate(street,house);
	}
}

function findFromForm(){
	var streetForm = document.getElementById('street').value;
	var houseForm = document.getElementById('house').value;
	if(streetForm == '' || houseForm == ''){
		document.getElementById('sidebar').innerHTML = 'Не введено';
	}
	else{
		document.getElementById('sidebar').innerHTML = getDate(streetForm,houseForm);
	}
}
