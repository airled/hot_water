ymaps.ready(init);
var myMap, myPlacemark, coordinates;

function init(){     
  myMap = new ymaps.Map("map", {
    controls: ["zoomControl", "fullscreenControl", "typeSelector"],
    center: [53.9, 27.55],
    zoom: 12
  });

  myMap.events.add('click', function(e) {
    coordinates = e.get('coords');
    // console.log(coordinates);
    getAddressByCoordinates(coordinates[0], coordinates[1])
    if (myPlacemark) {
      myPlacemark.geometry.setCoordinates(coordinates);
    }
    else {
      myPlacemark = new ymaps.Placemark(coordinates);
      myMap.geoObjects.add(myPlacemark);
    }
  });
}

function getAddressByCoordinates(lat, long){
  var geoURL = 'https://geocode-maps.yandex.ru/1.x/?sco=latlong&format=json&geocode=' + lat + ',' + long;
  
  $.ajax({
    url: geoURL,
    datatype: 'json'
  })
  .done(function(data){
    var addressLine = data.response.GeoObjectCollection.featureMember[0].GeoObject.metaDataProperty.GeocoderMetaData.AddressDetails.Country.AddressLine;
    if (addressLine.split(',').length == 3) {
      // var city = addressLine.split(',')[0].trim();
      var street = addressLine.split(',')[1].trim();
      var house = addressLine.split(',')[2].trim();
      // console.log(street + ', ' + house);
      $('#result').text('Адрес: ' + street + ', ' + house);
    }
    else {
      // console.log('Неточный адрес');
      $('#result').text('Неточный адрес');
    }
  });
}
