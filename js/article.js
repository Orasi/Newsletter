(function() {
  var $container;

  $container = $('.image-grid');

  $container.find('img').addClass('loading');

  $container.prepend('<div class="signal"></div>');

  $container.imagesLoaded(function() {
    $('.image-grid .signal').remove();
    $container.find('img').removeClass('loading').addClass('loaded');
    return $container.masonry({
      isFitWidth: true,
      itemSelector: 'img'
    });
  });

  $("#o").on('click', function() {
    return window.location.href = '../articles/secret_guess_who_information.html';
  });

  $(document).ready(function() {
    return $('[data-toggle=tooltip]').tooltip();
  });

}).call(this);
