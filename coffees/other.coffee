# other.coffee
jQuery ->
  # functions input_label
  input_label = ->
    label = $(@).parent().prev()
    if /^\s*$/.test(@value)
      label.show()
    else
      label.hide()

  text_area_key_up = (event)->
    event = event || window.event
    button = $(@).next()
    if event.keyCode == 13 and event.ctrlKey
      button.click()
    if /^\s*$/.test(@value)
      unless button.hasClass('disabled')
        button.addClass('disabled')
    else
      button.removeClass('disabled')

  text_area_blur = ->
    mp = $(@).parent()
    tag = @tagName.toLowerCase()
    if tag is "textarea"
      if /^\s*$/.test($(@).val())
        mp.parent().hide()
        mp.parent().prev().show()
    else
      mp.hide()
      mp.next().show()

  # 
  $('.js-menu').menu()
  $('.form.small input').on 'keyup', input_label
  $('.js-paginate').paginate(after: (data)-> $('#js-paginate-result').html(data.content) )
  $('.js-textarea').on('keyup', text_area_key_up).on('blur', text_area_blur)

  $('.js-form-page').form(after: (data)->
    $('#js-paginate-result').prepend(data.content)
    $('.js-textarea', $(@).parent()).blur())

  $('.js-form-nothing').form(after: (data)->
    $('.js-textarea', $(@).parent()).blur())

  $('.js-form-simple input').on 'focus', ->
    text_area_blur.call(@)
    $('.js-textarea', $(@).parent().next()).focus()

  setTimeout ->
    $('.form.small input').each(input_label)
  , 500


  false


