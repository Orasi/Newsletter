$container = $('.image-grid')
$container.imagesLoaded ->
  $container.masonry({
    isFitWidth: true,
    itemSelector: 'img'
  })
$(document).ready ->
  $('a[data-toggle=tooltip]').tooltip()