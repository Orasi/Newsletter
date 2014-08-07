$container = $('.image-grid')
$container.imagesLoaded ->
  $container.masonry({
    isFitWidth: true,
    itemSelector: 'img'
  })