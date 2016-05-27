$(document).ready(function() {
  $('#search-submit').click(function() {
    var street = $('#street').val().trim();
    var house = $('#house').val().trim();
    if (street === ''){
      $('#result').text('Нет улицы');
    }
    else if (house === '') {
      $('#result').text('Нет номера дома');
    }
    else {
      var url_for_date = Routes.root_path() + 'date?street=' + street + '&house=' + house;
      $.ajax({
        url: url_for_date
      })
      .done(function(data) {
        $('#result').text('Адрес: ' + street + ', ' + house + " | Отключение: " + data.date);
      });
    }
  });
});
