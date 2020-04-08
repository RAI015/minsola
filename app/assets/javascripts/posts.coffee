# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'change', '#post_prefecture_id', ->
  $.ajax(
    type: 'GET'
    url: '/posts/cities_select'
    data: {
      prefecture_id: $(this).val()
    }
  ).done (data) ->
    $('#cities_select').html(data)