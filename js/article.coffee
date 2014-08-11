$container = $('.image-grid')
$container.find('img').addClass('loading')
$container.prepend('<div class="signal"></div>')
$container.imagesLoaded ->
  $('.image-grid .signal').remove()
  $container.find('img').removeClass('loading').addClass('loaded')
  $container.masonry({
    isFitWidth: true,
    itemSelector: 'img'
  })
$(document).ready ->
  $('[data-toggle=tooltip]').tooltip()