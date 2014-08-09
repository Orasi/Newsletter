(function() {
  var $container;

  $container = $('.image-grid');

  $container.imagesLoaded(function() {
    return $container.masonry({
      isFitWidth: true,
      itemSelector: 'img'
    });
  });

  $(document).ready(function() {
    return $('[data-toggle=tooltip]').tooltip();
  });

}).call(this);
