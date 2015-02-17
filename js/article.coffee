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
$("#o").on 'click', ->
  window.location.href = '../articles/secret_guess_who_information.html'
$(document).ready ->
  $('[data-toggle=tooltip]').tooltip()