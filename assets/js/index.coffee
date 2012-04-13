$ ->
  $('#url-form').submit (event) ->
    event.preventDefault() unless $('#url-input').val()
