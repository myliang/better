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
  $('.form.small .fd > input').on 'keyup', input_label
  $('.js-paginate').paginate(after: (data)-> $('#js_paginate_result').html(data.content) )
  $('.js-textarea').on('keyup', text_area_key_up).on('blur', text_area_blur)

  $('.js-form-page').form(after: (data)->
    $('#js_paginate_result').prepend(data.content)
    $('.js-textarea', $(@).parent()).blur())

  $('.js-form-nothing').form(after: (data)->
    $('.js-textarea', $(@).parent()).blur())

  $('.js-form-simple input').on 'focus', ->
    text_area_blur.call(@)
    $('.js-textarea', $(@).parent().next()).focus()

  setTimeout ->
    $('.form.small .fd > input').each(input_label)
  , 500

  # delete
  $('a[rel=nofollow]').popup({content: ->
    method = @attr('data-method')
    href = @attr('href')
    token = $('meta[name=csrf-token]').attr('content')
    buffer = ['<form id="js_form_delete" method="post" action="', href, '">']
    buffer.push('<input name="utf8" type="hidden" value="&#x2713;" />')
    buffer.push('<input name="authenticity_token" type="hidden" value="', token, '" />')
    buffer.push('<input type="hidden" name="_method" value="', method, '"/>')
    buffer.push('你确定要删除吗？')
    buffer.push('<button type="button" class="btn red" onclick="$(\'#js_form_delete\').submit();">确定</button>')
    buffer.push('</form>')
    return buffer.join('')
  })

  false


