$ ->
  $('a.noodnik-postpone').click (event) -> 
    event.preventDefault()
    url = $(this).attr 'href'
    $box = $(this).parent()
    $box = $(this).parentsUntil('div.noodnik-nag').parent() unless $box.hasClass 'noodnik-nag'
    $.get url, ->
      $box.hide()

  $('a.noodnik-complete').click (event) ->
    url = $(this).data 'noodnik-complete-path'
    $.get url
