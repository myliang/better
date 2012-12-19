$ = jQuery

_form = (_self, option) ->
  $.extend(@, option)
  @self = $(_self)

  @

_form:: =
  go: ->
    @form_tag = @self.closest('form')
    return if(@self.is(@except))

    # before
    @before.call(@self)

    @loading = new util.loading(@self)
    url = @url()
    data = @form_tag.serialize() # @fields()

    console.log("ajax.data=", data)
    $.ajaxSetup({beforeSend: (xhr) ->
      token = $('meta[name=csrf-token]').attr('content')
      if token?
        xhr.setRequestHeader('X-CSRF-Token', token)
    })
    $.post(url, data, (msg) => @post_after(msg))
      .error (msg)=> @post_after(msg)
    false

  post_after: (msg)->
    if @reset?
      @reset_after()
    @loading.recover()
    @after.call(@self, msg)

  reset_after: ->
    $(':input', @form_tag).each ->
      type = @type
      tag = @tagName.toLowerCase()

      if tag is "textarea" or type is "text" or type is "email" or type is "password"
        @value = ""
      console.log('::::', type, ":::", tag)

  # fields: ->
  #   # step get input hidden value
  #   data = {}
  #   @field(data, 'input:hidden')
  #   @field(data, 'input:text')
  #   @field(data, 'input[type=email]')
  #   @field(data, 'input[type=password]')
  #   @field(data, 'select')
  #   @field(data, 'input:radio:checked')
  #   @field(data, 'textarea')
  #   @field(data, 'input:checkbox:checked')
  #   data
  # 
  # field: (data, selector) ->
  #   $(selector, @form_tag).each ->
  #     if util.unempty(@name)
  #       if data[@name]?
  #         data[@name] += ',' + $(@).val()
  #       else
  #         data[@name] = $(@).val()
  #   data
  url: ->
    @form_tag.attr('action') + @url_suffix


$.fn.form = (option) ->
  option = $.extend({}, $.fn.form.defaults, option || {})
  binder = if option.live then "live" else "bind"
  @[binder] option.trigger_name(), ->
    $(@).wrapData(option.cache_key_suffix, -> new _form(@, option)).go()
    false
  @

$.fn.form.defaults =
  cache_key_suffix: "form"
  live: false,
  trigger: 'click'
  except: ".active,.disabled"
  url_suffix: ".json"
  reset: true
  trigger_name: ->
    @trigger + "." + @cache_key_suffix

  after: ->
  before: ->
