util =
  data: (_self, key, value_callback) ->
    cache = _self.data(key)
    # console.log(':::cache', key, cache)
    unless cache?
      cache = value_callback.call(_self)
      _self.data(key, cache)
    cache
  loading: (obj) ->
    @target = obj
    @old = obj.text().replace(/(\r|\n|\r\n|\s)+/g, '')
    obj.addClass('disabled')
    obj.html(obj.html().replace(@old, "&bull;&nbsp;&bull;&nbsp;&bull;"))
    @
  unempty: (obj)->
    obj? and not/^\s+$/.test(obj)
  scroll: ->
    w: $(document.body)[0].scrollWidth, h: $(document.body)[0].scrollHeight
  offset: (source, target, arrow)-> # cal target offset(top, left)
    @source = arguments[0].offset()
    @source.w = arguments[0].outerWidth()
    @source.h = arguments[0].outerHeight()
    @target =
      w: arguments[1].width(), h: arguments[1].height()
      outer: {w: arguments[1].outerWidth(), h: arguments[1].outerHeight()}
    @target.padding =
      w: @target.outer.w - @target.w
      h: @target.outer.h - @target.h


    @arrow_size = arguments[2]
    @scroll = util.scroll()
    if arguments.length >= 4
      @content = {w: arguments[3].outerWidth(), h: arguments[3].outerHeight()}
      @target.outer.w = @content.w + @target.padding.w
      @target.outer.h = @content.h + @target.padding.h
    @

util.loading:: =
  recover: ->
    @target.html(@old)
util.offset:: =
  arrow: (pos) ->
    ret = left: 0, top: 0, position: "absolute"
    border = 1
    switch pos
      when "left"
        ret.left = @source.left - @arrow_size - border
        ret.top = @source.top + @source.h / 2
      when "right"
        ret.left = @source.left + @source.w + @arrow_size + border
        ret.top = @source.top + @source.h / 2
      when "top"
        ret.left = @source.left + @source.w / 2
        ret.top = @source.top - @arrow_size - border
      when "bottom"
        ret.top = @source.top + @source.h + @arrow_size + border
        ret.left = @source.left + @source.w / 2

    ret
  auto: ->
    h = @source.top / (@scroll.h - @source.top)
    w = @source.left / (@scroll.w - @source.left)
    w1 = @scroll.w - @source.left
    if(@source.left > 0)
      w1 = w1 / @source.left
    if h > w
      if h > w1 then "top" else "right"
    else
      if h > w1 then "left" else "bottom"
  center: ->
    ret = top: 0, left: 0
    ret.top = (@scroll.h - @target.outer.h) / 2 if @scroll.h > @target.outer.h
    ret.left = (@scroll.w - @target.outer.w) / 2 if @scroll.w > @target.outer.w
    @_wrap_result(ret)
  top: ->
    ret = top: @source.top - @target.outer.h - @arrow_size
    @_top_bottom(ret)
  bottom: ->
    ret = top: @source.top + @source.h + @arrow_size
    @_top_bottom(ret)
  left: ->
    ret = left: @source.left - @target.outer.w - @arrow_size
    @_left_right(ret)
  right: ->
    ret = left: @source.left + @source.w + @arrow_size
    @_left_right(ret)
  _left_right: (opt)->
    opt.top = @source.top + @source.h / 2 - @target.outer.h / 2
    muti = opt.top + @target.outer.h - @scroll.h
    if opt.top < 0
      opt.top = 0
    else if muti > 0
      opt.top -= muti
    @_wrap_result(opt)
  _top_bottom: (opt)->
    opt.left = @source.left + @source.w / 2 - @target.outer.w / 2
    muti = opt.left + @target.outer.w - @scroll.w
    if opt.left < 0
      opt.left = 0
    else if muti > 0
      opt.left -=  muti
    @_wrap_result(opt)
  _wrap_result: (opt)->
    opt.w = @target.w
    opt.h = @target.h
    if @content?
      opt.w = @content.w
      opt.h = @content.h
    opt.position = "absolute"
    opt

# window extends
window.util = util
$ = jQuery

# extend String
# String:: =
  # empty: ->
    # util.empty(@)
$.fn.wrapData = (key, callback) ->
  util.data(@, key, callback)

$.fn.outerHtml = ->
  $('<div>').append(@.eq(0).clone().show()).html()

$.fn.rebind = (event_name, func)->
  @.unbind(event_name).bind(event_name, func)

