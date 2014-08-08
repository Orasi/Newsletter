$container = $('.image-grid')
$container.imagesLoaded ->
  $container.masonry({
    isFitWidth: true,
    itemSelector: 'img'
  })
$(document).ready ->
  $('[data-toggle=tooltip]').tooltip()