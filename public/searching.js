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
	return (JSON.parse(request(url)).date);
}

function getAddressWithDate(position){
	var url = 'https://geocode-maps.yandex.ru/1.x/?sco=latlong&format=json&geocode=' + String(position).replace(/[\(\) ]/g,'');
	addressLine = JSON.parse(request(url)).response.GeoObjectCollection.featureMember[0].GeoObject.metaDataProperty.GeocoderMetaData.AddressDetails.Country.AddressLine;
	if(addressLine.split(',').length == 3){
		city = addressLine.split(',')[0].trim();
		street = addressLine.split(',')[1].trim();
		house = addressLine.split(',')[2].trim();
		return street + ', ' + house + '<br>' + 'Отключение: ' + getDate(street,house);
	}
	else{
		return 'Неточный адрес';
	}
}

function findFromForm(){
	var streetForm = document.getElementById('street').value;
	var houseForm = document.getElementById('house').value;
	if(streetForm == '' || houseForm == ''){
		setResult('Не введено');
	}
	else if(notValidObject(streetForm) || notValidObject(houseForm)){
		setResult('Неправильный ввод');
	}
	else{
		setResult(getDate(streetForm,houseForm));
	}
}

function setResult(result){
	document.getElementById('sidebar').innerHTML = result;
}

function notValidObject(object){
	if(object.match(/[^А-Яа-я0-9\.\ ]/)){
		return true;
	}
	else{
		return false;
	}
}