# Konami implementation
easter_egg = new Konami()
easter_egg.code = ->
  alert('Turn on your volume...')
  window.location.replace('http://www.danbarham.com/dinklage/')
easter_egg.load()