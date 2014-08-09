(function() {
  var easter_egg;

  easter_egg = new Konami();

  easter_egg.code = function() {
    alert('Turn on your volume...');
    return window.location.replace('http://www.danbarham.com/dinklage/');
  };

  easter_egg.load();

}).call(this);
