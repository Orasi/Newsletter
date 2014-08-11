(function() {
  var $container;

  $container = $('.image-grid');

  $container.imagesLoaded(function() {
    $container.find('img').addClass('loaded');
    return $container.masonry({
      isFitWidth: true,
      itemSelector: 'img'
    });
  });

  $(document).ready(function() {
    return $('[data-toggle=tooltip]').tooltip();
  });

}).call(this);
