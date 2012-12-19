$=jQuery

cache_objects = []  # popup object

# menu
_menu = (_self, option)->
  $.extend(@, option)
  @self = $(_self)
  @active = @self
  @active = @self.parent() if @self.parent().is('li')

  @

_menu:: =
  toggle: ->
    return false if @self.is(@except)
    if @active.hasClass('active')
      @hide()
    else
      @show()
    false
  show: ->
    @body = @get_content()
    # source_t = @self.offset().top
    # scroll_h = util.scroll().h

    source_padding = (@self.parent().outerHeight() - @self.outerHeight())/2
    top = @self.outerHeight() + source_padding
    if(@direction is "up")
      top -= @body.outerHeight(true) + @self.outerHeight()

    @body.css({top: top}).show()
    @active.addClass('active')
  hide: ->
    @body.hide()
    @active.removeClass('active')
  get_content: ->
    @self.next()


$.fn.menu = (option)->
  option = $.extend({}, $.fn.menu.defaults, option || {})
  # bind event
  binder = if option.live then "live" else "bind"
  @[binder] option.trigger_name(), (event)->
    p = $(@).wrapData(option.cache_key_suffix, -> new _menu(@, option))
    cache_objects.push(p)
    p.toggle()
    false
  @

$.fn.menu.defaults = $.extend({}, $.fn.popup.defaults, {
  cache_key_suffix: "menu"
  direction: "down"
})

# bind html hide
$(document).on 'click.menu', ->
  $.each(cache_objects, (index, ele)-> ele.hide())


