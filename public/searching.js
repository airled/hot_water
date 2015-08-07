function getDate(street,house){
	var url = 'http://hotwater.muzenza.by/date?street=' + String(street) + '&house=' + String(house);
	// var url = 'http://localhost:4567/date?street=' + String(street).replace(/ /g,'+') + '&house=' + String(house);
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open("GET", url, false);
	xmlHttp.send(null);
	return (JSON.parse(xmlHttp.responseText).date);
}

function findFromForm() {
	var streetForm = document.getElementById('street').value;
	var houseForm = document.getElementById('house').value;
	document.getElementById('sidebar').innerHTML = getDate(streetForm,houseForm);
}