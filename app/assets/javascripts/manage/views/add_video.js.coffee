App.Views.AddVideo = Backbone.View.extend
  events:
    "submit" : "add"

  initialize: ->
    _.bindAll this, "add"
    @$links = @$("textarea[name=links]")
    @$button = @$(".button.primary")
    @action = @$el.attr("action")

  add: (e) ->
    e.preventDefault()

    urls = @$links.val()

    if urls? and urls != "" and @action?
      @_loading()

      video = new App.Models.Video()

      get = video.create(@action, urls)

      get.done (state, msg) =>
        window.location.reload()
        @_clearForm()
        @_ready()

      get.fail (msg) =>
        alert msg
        @_clearForm()
        @_ready()

    else
      alert "please add a url"

  _clearForm: ->
     @$links.val ""

  _loading: ->
    @$el.addClass "loading"
    @$button.attr "disabled", "disabled"

  _ready: ->
    @$el.removeClass "loading"
    @$button.removeAttr "disabled"

