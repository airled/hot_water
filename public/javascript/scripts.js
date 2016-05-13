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
    console.log(coordinates);
    if (myPlacemark) {
      myPlacemark.geometry.setCoordinates(coordinates);
    }
    else {
      myPlacemark = new ymaps.Placemark(coordinates);
      myMap.geoObjects.add(myPlacemark);
    }
  });
}
