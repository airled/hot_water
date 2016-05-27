$(document).ready(function() {
  $('#search-submit').click(function() {
    var street = $('#street').val();
    var house = $('#house').val();
    var url_for_date = Routes.root_path() + 'date?street=' + street + '&house=' + house;
    $.ajax({
        url: url_for_date
      })
      .done(function(data) {
        $('#result').text('Адрес: ' + street + ', ' + house + " | Отключение: " + data.date);
      });
  });
});
