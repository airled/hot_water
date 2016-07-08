$(document).ready(function() {

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
      });
    }
  });
});
