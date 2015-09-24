// var serverURL = 'http://localhost:9292/'
var serverURL = 'http://hotwater.muzenza.by/'

function encode(string){
	return encodeURIComponent(string);
}

function getAddressWithDate(position){
	var geoURL = 'https://geocode-maps.yandex.ru/1.x/?sco=latlong&format=json&geocode=' + String(position).replace(/[\(\) ]/g,'');
	$.ajax({
		url: geoURL,
		datatype: 'json'
	})
	.done(function(data){
		var addressLine = data.response.GeoObjectCollection.featureMember[0].GeoObject.metaDataProperty.GeocoderMetaData.AddressDetails.Country.AddressLine;
		if(addressLine.split(',').length == 3){
			var city = addressLine.split(',')[0].trim();
			var street = addressLine.split(',')[1].trim();
			var house = addressLine.split(',')[2].trim();
			var dateURL = serverURL + 'date?street=' + encode(street) + '&house=' + encode(house);
			$.ajax({
				url: dateURL,
				async: true,
				datatype: 'json'
			})
			.done(function(data){
				setResult(street + ', ' + house + '<br>' + 'Отключение: ' + JSON.parse(data).date);
			});
		}
		else{
			setResult('Неточный адрес');
		}
	});
}

function findFromForm(){
	var streetForm = $('#form_street').val();
	var houseForm = $('#form_house').val();
	if(streetForm == '' || houseForm == ''){
		setResult('Не введено');
	}
	else if(notValidObject(streetForm) || notValidObject(houseForm)){
		setResult('Неправильный ввод');
	}
	else{
		var dateURL = serverURL + 'date?street=' + encode(streetForm) + '&house=' + encode(houseForm);
		$.ajax({
			url: dateURL,
			datatype: 'json'
		})
		.done(function(data){
			setResult(JSON.parse(data).date);
		});
	}
}

function setResult(result){
	$("#results").html(result);
}

function notValidObject(object){
	if(object.match(/[^А-Яа-я0-9ё\.\ \-]/)){
		return true;
	}
	else{
		return false;
	}
}

function visualizePanel(){
	$("#panel").addClass("visible");
}

$(document).ready(function(){
	$("#form_street").val('');
	$("#form_house").val('');
	$("#form_street").click(visualizePanel);
	$("#form_house").click(visualizePanel);
	$("#form_button").click(visualizePanel);
	$("#form_button").click(findFromForm);
	$("#form_street").autocomplete({
		source: serverURL + 'auto_street'
	});
});

