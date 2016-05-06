# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(window).bind 'page:change', ->
  getTotal = ->
    total = 0
    n = 0
    $.each $('.cart > tr > td:last-child'), ->
      total += Number(($(this).text()).replace('$', ''))
      n = total.toFixed(2)
    return n

  setTotal = ->
    $('.cart > tr > td:last-child').last().empty()
    total = getTotal()
    $('.cart > tr > td:last-child').last().append("$ " + total + "")
    return

  setSubTotal = (obj)->
    obj = $(obj).parent().parent().parent().find('.product-price')
    subtotal = 0
    price = Number(($(obj).text()).replace('$', ''))
    quantity = $(obj).parent().find('.quantity')
    subtotal = Number((quantity.text()) * price)
    n = subtotal.toFixed(2)
    $(obj).parent().find('.subtotal').empty().append("$" + n + "")
    setTotal()
    return

  addProduct = (obj) ->
    num = Number(($(obj).next().text()).replace('$', '')) + 1
    $(obj).next().empty().append "" + num + ""
    return

  $('.inline-flex > button').on 'click', ->
    if $(this).hasClass('add-product')
      addProduct(this)
      setSubTotal(this)
    return

  setTotal()
  return
