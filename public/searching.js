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
	var url = 'http://hotwater.muzenza.by/date?street=' + String(street) + '&house=' + String(house);
	// var url = 'http://localhost:4567/date?street=' + encode(String(street)) + '&house=' + encode(String(house));
	return (JSON.parse(request(url)).date);
}

function findFromForm(){
	var streetForm = document.getElementById('street').value;
	var houseForm = document.getElementById('house').value;
	document.getElementById('sidebar').innerHTML = getDate(streetForm,houseForm);
}