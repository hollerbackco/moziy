App.Views.SharingModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/sharing_modal']
  events:
    "click #share-facebook": "shareFb"
    "click #share-twitter": "shareTw"

  initialize: ->
    _.bindAll this, "show", "close", "_showErrors", "_success", "_validateForm"

    @listenTo App.vent, "modals:close", @close

    @$el.modal().modal("hide")

  render: ->
    @$el.html @template
      url: @_airingUrl()
      title: @model.get "title"

  show: (model) ->
    @model = model
    App.vent.trigger "modals:close"
    @render()
    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  shareTw: ->
    href = @$("#share-twitter a").attr("href")
    @_jsPopup href
    false

  shareFb: ->
    obj =
      method: 'feed'
      name: @model.get("title")
      caption: @model.get("description")
      url: @_airingUrl()
      picture: @model.get("channel").cover_art.url

    FB.ui obj, (response) =>
      if response and response.post_id
        App.analytics.vent.trigger "airing:share", @model
        App.vent.trigger "notice", "post was published"
      else
        App.vent.trigger "error", 'Post was not published.'

  _success: ->
    @$("form").addClass "submitted"
    App.analytics.vent.trigger "airings:share"

  _showErrors: (errors) ->
    @$("form").addClass "has-errors"

    @$errors.empty()

    if errors?
      _.each errors, (error) =>
        div = $("<div />").addClass("error").html(error)
        @$errors.append div

  _validateForm: (callback) ->
    value = @$("input[name=email]").val()

    if errors? and errors.length == 0
      callback(value)
    else
      @showErrors()

  _airingUrl: ->
    "http://www.moziy.com/#{@model.get('channel_slug')}/video?v=" + "#{@model.id}"

  _jsPopup: (url) ->
    width  = 575
    height = 400
    left   = ($(window).width()  - width)  / 2
    top    = ($(window).height() - height) / 2
    opts   = 'status=1' +
      ',width='  + width  +
      ',height=' + height +
      ',top='    + top    +
      ',left='   + left

    window.open(url, 'twitter', opts)

    false
