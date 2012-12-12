$ = jQuery

cache_objects = []  # popup object

_popup =(self, option) ->
  $.extend(@, option)
  @self = $(self)
  @

_popup:: =
  toggle: ->
    return if @self.is(@except)
#    console.log(':::::', @self.hasClass('active'))
    unless @self.hasClass('active')
      @show()
      @self.addClass('active')
    else
      @hide()
      @self.removeClass('active')

    @
  show: ->
    @body = @get_content()
    offset = new util.offset(@self, @body, @offset)
    temp_offset = offset[@direction]()
    if @direction is "auto"
      @direction = temp_offset
      temp_offset = offset[temp_offset]()
    else temp_offset

    $('#' + @arrow_doc_id).addClass(@direction).css(offset.arrow(@direction))
    @body.css(temp_offset).show()
  hide: ->
    if @is_remove_if_hide
      @body.remove()
    else
      @body.hide()
    $('#' + @arrow_doc_id).remove()
  get_content: ->
    href = @self.attr('href')
    if typeof(@content) == "function"
      @content()
    else if typeof(@content) == "object" and @content?
      @content
    else if href? and href.length > 1 and href[0] is "#"
      is_remove_if_hide = true
      $(href)
    else
      @default_content()

  default_content: ->
    title = @self.attr('data-title')
    content = @self.attr('data-content')

    if title?
      title = """<div class="header">#{title}</div>"""
    else
      title = ""

    content = $("""
      <div style="display: none; max-width: #{@max_width}">
        <div class="popup border">
          #{title}
          <div class="body">
            #{content}
          </div>
        </div>
      </div>
    """)
    $(document.body).append("<div id=\"#{@arrow_doc_id}\" class=\"#{@arrow_doc_class}\"></div>")
    content.appendTo(document.body)
    content

$.fn.popup = (option) ->
  option = $.extend({}, $.fn.popup.defaults, option || {})
#  return if option.content?

  binder = if option.live then "live" else "bind"
  @[binder] option.trigger_name(), ->
    p = $(@).wrapData(option.cache_key_suffix, -> new _popup(@, option))
    cache_objects.push(p)
    p.toggle()
    false

#  cache_objects

$.fn.popup.defaults =
  cache_key_suffix: "popup"
  direction: "auto" # center left top right bottom
  live: false
  trigger: "click"
  offset: 0
  except: '.disabled,:disabled,:animated'
  content: null  # jquery object or string
  is_remove_if_hide: true # if hide content is or not remove
  arrow_doc_id: "js-arrow-popup"
  arrow_doc_class: "arrow-popup"
  max_width: "660px"
  trigger_name: ->
    @trigger + "." + @cache_key_suffix

  after:
    show: -> # @addClass('actived')
    hide: -> # @removeClass('actived')

$.fn.popup.constructor = _popup

# bind html hide
$(document).on 'click', ->
  $.each(cache_objects, (index, ele)-> ele.toggle())
  cache_objects = []


###
$ = jQuery


_popup = (self, option) ->
  $.extend(@, option)
  @self = $(self)
  @target = @_target()
  @target.appendTo(document.body)

  # bind event
  # binder = if @live then "live" else "bind"
  # @self[binder](@trigger+".popup", (event)=> @toggle(event))

  # target old offset
  to_offset = new util.offset(@self, @target, @arrow)
  @to_os = @_target_offset(to_offset)
  @to_os.width = @to_os.w
  @to_os.height = @to_os.h
  @to_os.overflow = 'hidden'
  @to_os.opacity = 0

  @

_popup:: =
  toggle: ->
    return false if @target.is(@except) or @target.find('.popup-box').is(@except)

    @content = @_content()
    # bind html hide
    $(document).rebind 'click.popup', (event)=> @hide(true)


    # target new offset(contain content)
    tn_offset = new util.offset(@self, @target, @arrow, @content)
    @tn_os = @_target_offset(tn_offset)
    @tn_os.width = @tn_os.w
    @tn_os.height = @tn_os.h
    @tn_os.opacity = 1

    # arrow
    @tn_arrow = tn_offset.arrow(@position)

    # is or not target bind date self
    @isself = if @target.data('bind_data')? then @target.data('bind_data').is(@self) else true
    if @target.css('display') is 'none' or !@isself
      @show()
    else
      @hide()
    false
  show: ->
    @after.show.call(@self)
    tc_before = left: 0, top: 0
    tc_after = opacity: 1, top: 0

    switch @position
      when "left", "center"
        tc_before.left = @tn_os.width
        tc_after.left = 0
      when "right"
        tc_before.left = -@tn_os.width
        tc_after.left = 0
      when "top"
        tc_before.top = @tn_os.height
        tc_after.top = 0
      when "bottom"
        tc_before.top = -@tn_os.height
        tc_after.top = 0

    # is self
    if @isself
      @target.css(@to_os)
      $('.popup-arrow').css(@tn_arrow)
    else
      @hide()

    $('.popup-arrow').addClass(@position).show().animate(@tn_arrow)
    @target.show().animate(@tn_os,
      => 
        @target.find('.popup-box').css(tc_before)
        .html(@content.outerHtml()).animate(tc_after,
          => @target.css({overflow: 'visible'})))

    @target.data('bind_data', @self)

  # flag is or not self
  hide: (flag)->
    # return if @target.css('display') == 'none'
    if flag
      $(document).off 'click.popup'

    @after.hide.call(if @isself or flag then @self else @target.data('bind_data'))
    tc = opacity: 0
    switch @position
      when "left", "center"
        tc.left = @tn_os.width
      when "right"
        tc.left = -@tn_os.width
      when "top"
        tc.top = @tn_os.height
      when "bottom"
        tc.top = -@tn_os.height

    @target.css({overflow: 'hidden'}).find('.popup-box').animate(tc,
      => 
        if @isself or flag 
          $('.popup-arrow').removeClass(@position).hide()
          @target.animate(@to_os, => @target.hide()))

    @target.data('bind_data', null)

  _target_offset: (util_offset)->
    t_os = util_offset[@position]()
    # if position is auto to cal 
    if @position is 'auto'
      @position = t_os
      t_os = util_offset[@position]()
    t_os
  _target: ->
    t = $('.popup-box-outer')
    unless t[0]?
      t = $(@template) 
      $(document.body).append('<div class="popup-arrow"></div>')
    t
  _content: ->
    $(@self.attr('href'))

$.fn.popup = (option) ->
  option = $.extend({}, $.fn.popup.defaults, option || {})
  binder = if option.live then "live" else "bind"
  @[binder] option.trigger + ".popup", -> 
    $(@).wrapData('popup', -> new _popup(@, option)).toggle()

  @

$.fn.popup.defaults =
  position: "auto" # center left top right bottom
  live: false
  trigger: "click"
  arrow: 20
  duration: 1000
  except: ':animated'
  template: """<div class="popup-box-outer">
      <div class="popup-box"></div>
    </div>
    """
  after: 
    show: -> @addClass('actived')
    hide: -> @removeClass('actived')


# bind html hide
$(document).on 'click.popupouter', '.popup-box-outer',
  (event)-> 
    event.stopPropagation()

###
