$container = $('.image-grid')
$container.imagesLoaded ->
  $container.find('img').addClass('loaded')
  $container.masonry({
    isFitWidth: true,
    itemSelector: 'img'
  })
$(document).ready ->
  $('[data-toggle=tooltip]').tooltip()