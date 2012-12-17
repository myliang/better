# other.coffee
jQuery ->
  # 
  $('.js-menu').menu()
  $('.form.small input').on 'keyup', ->
    label = $(@).parent().prev()
    if /^\s*$/.test(@value)
      label.show()
    else
      label.hide()
