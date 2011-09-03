$ ->
  $('.postpone-link').click (event) -> 
    event.preventDefault()
    url = $(this).attr 'href'
    box = $(this).parentsUntil('div.noodnik-nag').parent()
    $.get url, ->
      box.hide()
