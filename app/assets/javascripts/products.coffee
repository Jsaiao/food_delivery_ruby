# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(window).bind 'page:change', ->

  $('.add-product').on 'click', ->
    $.ajax
      type: 'POST'
      url: '/add_product/' + $(this).data('id')
    return

  $('.remove-product').on 'click', ->
    $.ajax
      type: 'POST'
      url: '/one_less_product/' + $(this).data('id')
    return

  $('.view-product ').on 'click', ->
    $.ajax
      type: 'GET'
      dataType: 'script'
      url: '/view_product/' + $(this).data('id')
    return
  return