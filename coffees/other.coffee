# other.coffee
jQuery ->
  # functions input_label
  input_label = ->
    label = $(@).parent().prev()
    if /^\s*$/.test(@value)
      label.show()
    else
      label.hide()

  # 
  $('.js-menu').menu()
  $('.js-paginate').paginate(after: (data)-> $('#js-paginate-result').html(data.content) )
  $('.js-form').form(after: (data)-> $('#js-paginate-result').prepend(data.content) )
  $('.form.small input').on 'keyup', input_label

  setTimeout ->
    $('.form.small input').each(input_label)
  , 1000


  false


