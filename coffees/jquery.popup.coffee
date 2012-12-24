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
    else
      @hide()

    @
  show: ->
    @body = @get_content()
    @arrow_doc = $("<div class=\"#{@arrow_doc_class}\"></div>")
    $(document.body).append(@body).append(@arrow_doc) # call body information

    @body.off('click').on 'click', -> false
    $('.close', @body).off('click').on 'click', => @hide(); false

    offset = new util.offset(@self, @body, @offset)
    temp_offset = offset[@direction]()
    if @direction is "auto"
      @direction = temp_offset
      temp_offset = offset[temp_offset]()
    else temp_offset

    @arrow_doc.addClass(@direction).css(offset.arrow(@direction))
    @body.css(temp_offset).show()

    # add class acitve
    @self.addClass('active')
    @
  hide: ->
    if @is_remove_if_hide
      @body.remove()
    else
      @body.hide()
    @arrow_doc.remove()

    # remove class active
    @self.removeClass('active')
    @
  get_content: ->
    href = @self.attr('href')
    if typeof(@content) == "function"
      @default_content(@content.call(@self))
    else if typeof(@content) == "object" and @content?
      @content
    else if href? and href.length > 1 and href[0] is "#"
      is_remove_if_hide = true
      $(href)
    else
      @default_content()

  default_content: ->
    title = @self.attr('data-title')
    unless title?
      title = "提示信息"
    if arguments.length <= 0
      content = @self.attr('data-content')
    else
      content = arguments[0]

    if title?
      title = """<div class="header">#{title}<a href="#" class="close">&times</a></div>"""
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
  offset: 10
  except: '.disabled,:disabled,:animated'
  content: null  # jquery object or string
  is_remove_if_hide: true # if hide content is or not remove
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
  $.each(cache_objects, (index, ele)-> ele.hide())
  cache_objects = []


