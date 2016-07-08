$(document).ready(function() {

  var myPlacemarkForm;

  $("#address").autocomplete({
    source: Routes.autocomplete_street_path()
  });

  $('#search-submit').click(function() {
    var address = $('#address').val().trim();
    if (address === ''){
      $('#result').text('Адрес не введен');
    }
    else {
      var url_for_date = Routes.root_path() + 'date?address=' + address;
      $.ajax({
        url: url_for_date
      })
      .done(function(data) {
        $('#result').text("Отключение: " + data.date);
          if (data.date !== 'Неполный адрес') {
            $.ajax({
              url: 'https://geocode-maps.yandex.ru/1.x/?format=json&result=1&geocode=' + address.replace(' ', '+') + '.'
            })
            .done(function(data) {
              var coordinates = data.response.GeoObjectCollection.featureMember[0].GeoObject.Point.pos.split(' ');
              var coordFl = [parseFloat(coordinates[1]), parseFloat(coordinates[0])];
              myMap.setCenter(coordFl);
              myMap.setZoom(17);
              if (myPlacemarkForm) {
                myPlacemarkForm.geometry.setCoordinates(coordFl);
              }
              else {
                myPlacemarkForm = new ymaps.Placemark(coordFl, {}, {preset: "islands#dotCircleIcon", iconColor: '#ff0000'});
                myMap.geoObjects.add(myPlacemarkForm);
              }
            });
          }
      });

    }
  });
});
