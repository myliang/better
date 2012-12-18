# paginate
$ = jQuery
cache_objects = []

_paginate = (_self, option)->
  $.extend(@, option)
  @self = $(_self)

  at = @
  $('a', @self).on(@trigger, -> at.go(@); false )

  if @self.attr('data-url')?
    @url = @self.attr('data-url')

  if @url?
    @step(0)

  @

_paginate:: =
  go: (node)->
    @node = $(node)
    try
      self_p = $(node).parent()
      return if self_p.is(@except)
      if self_p.hasClass('prev')
        @prev()
      else if self_p.hasClass('next')
        @next()
    catch error
    @
  next: ->
    return unless @is_next()
    @step(1)
  prev: ->
    return unless @is_prev()
    @step(-1)
  step: (offset)->
    @page += offset
    if @node?
      @loading = new util.loading(@node)
    params = {}
    params[@page_name] = @page
    $.get(@url + @url_suffix, params, (data)=> @get_after(data))
      .error (data)=> @get_after(data)
    @
  total_pages: ->
    if @total_rows?
      @total_rows/@page_rows + (@total_rows%@page_rows > 0 ? 1 : 0)
    else 0
  is_prev: -> @page > 1
  is_next: ->
    @page < @total_pages()
  get_after: (data)->
    if @page_rows?
      @page_rows = data.per_page
      @total_rows = data.total_pages
    @after(data)
    @set_other()
    if @node?
      @loading.recover()
  set_other: ->
    # alert(@total_pages())
    if @total_pages() <= 1
      @self.remove()
      return
    p = $('.prev a', @self)
    n = $('.next a', @self)
    $('.current a', @self).text(@page)
    if @is_prev()
      if p.hasClass('disabled')
        p.removeClass('disabled')
    else
      p.addClass('disabled')

    if @is_next()
      if n.hasClass('disabled')
        n.removeClass('disabled')
    else
      n.addClass('disabled')


$.fn.paginate = (option)->
  option = $.extend({}, $.fn.paginate.defaults, option || {})
  @each ->
    $(@).wrapData(option.cache_key_suffix, -> new _paginate(@, option))
  @

$.fn.paginate.defaults =
  url: null
  except: ".disabled"
  url_suffix: ".json"
  page: 1 # 当前的页数
  page_rows: 20 # 每页显示的数量
  total_rows: null # 总条数
  cache_key_suffix: 'paginate'
  trigger: 'click'
  page_name: 'page'
  trigger_name: -> @trigger
  after: (msg)->
