$ = jQuery

get_tip = (_self, option)->
  $(_self).wrapData(option.cache_key_suffix, -> new _tip(_self, option))

# _tip function
_tip = (_self, option) ->
  $.extend(@, option)
  @self = $(_self)
  @

_tip:: = $.extend({}, $.fn.popup.constructor::, {
  get_content: ->
    title = @self.attr('data-title')

    content = $("""
      <div style="display: none; max-width: #{@max_width}">
        <div class="tip">
          #{title}
        </div>
      </div>
    """)
    content
})

$.fn.tip = (option) ->
  option = $.extend({}, $.fn.tip.defaults, option || {})
#  return if option.content?

  binder = if option.live then "live" else "bind"

  eventin = if option.trigger is "hover" then "mouseenter" else "foucs"
  eventout = if option.trigger is "hover" then "mouseleave" else "blur"

  if option.trigger.indexOf "click"
    @[binder](option.trigger_name(), ->
#      console.log('::::::', @)
      get_tip(@, option).toggle()
      false)

  else
    @[binder](eventin, ->
      get_tip(@, option).toggle()
      false)[binder](eventout, ->
        get_tip(@, option).toggle()
        false)
  @

$.fn.tip.defaults = $.extend({}, $.fn.popup.defaults, {
  cache_key_suffix: "tip"
  offset: 8
  is_remove_if_hide: true
  trigger: "hover"
  arrow_doc_class: "arrow-tip"
  max_width: "260px"
})

  # bind event
#  binder = if @live then "live" else "bind"
#  eventin = if @trigger is "hover" then "mouseenter" else "foucs"
#  eventout = if @trigger is "hover" then "mouseleave" else "blur"
#  @self[binder](eventin, => @enter())[binder](eventout, => @leave())[binder]('click.tip', => @leave())
#  @
#_tip:: =
#  toggle: ->
#    if @is_show then @leave() else @enter()
#  enter: ->
#    return if @self.is(@except)
#    @show()
#    @is_show = true
#  leave: ->
#    @hide()
#    @is_show = false
#  show: ->
#    @el = $(@template)
#    @set_content()
#    @el.hide().appendTo(document.body)
#
#    offset = new util.offset(@self, @el, @arrow)
#    tp = offset[@position]()
#    if @position is 'auto'
#      @position = tp
#      tp = offset[@position]()
#    @el.css(tp).addClass(@position)
#
#    if @animation
#      @el.fadeIn 'fast'
#    else
#      @el.show()
#  hide: ->
#    return unless @el?
#    if @animation
#      @el.fadeOut 'fast', -> $(@).remove()
#    else
#      @el.remove()
#  set_content: ->
#    @el.find('.tip').html(@get_content())
#  get_content: ->
#    @content or @self.attr 'original-title'
#
#get_tip = (_self, option)->
#  $(_self).wrapData(option.cache_key, -> new _tip(@, option))
#
#
#$.fn.tip = (option) ->
#  option = $.extend({}, $.fn.tip.defaults, option || {})
#  binder = if option.live then "live" else "bind"
#  eventin = if option.trigger is "hover" then "mouseenter" else "foucs"
#  eventout = if option.trigger is "hover" then "mouseleave" else "blur"
#  @[binder](eventin, ->
#    get_tip(@, option).enter())[binder](eventout, ->
#      get_tip(@, option).leave())[binder]('click.tip', ->
#        get_tip(@, option).leave()
#    )
#  @
#
#$.fn.tip.constructor = _tip
#
#$.fn.tip.defaults =
#  cache_key: "tip"
#  position: 'auto' #top bottom right left
#  arrow: 5
#  live: false
#  trigger: 'hover'
#  animation: true
#  content: null
#  template: '<div class="tip-outer"><div class="tip"></div></div>'
#  except: ".actived"
#
