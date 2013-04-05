App.Views.CurrentSharing = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/current_sharing']

  events:
    "click #sharing-button": "share"
    "click .share-tw":  "shareTw"
    "click .share-facebook": "shareFb"

  initialize: ->
    _.bindAll this, "share", "shareFb", "shareTw", "_jsPopup"
    @listenTo App.vent, "airings:play", @show

  show: (airing) ->
    @model = airing
    @render()

  render: ->
    @$el.html @template @model.toJSON()

  share: ->
    App.vent.trigger "modals:share", @model

  shareTw: (event) ->
    App.analytics.vent.trigger "airing:share", @model, "twitter"
    event.preventDefault()
    href = @$(".share-tw").attr("href")
    @_jsPopup href
    false

  shareFb: ->
    obj =
      method: 'feed'
      name: @model.get("title")
      caption: @model.get("description")
      link: decodeURIComponent(@model.get("url"))

    FB.ui obj, (response) =>
      if response and response.post_id
        App.analytics.vent.trigger "airing:share", @model, "facebook"
        App.vent.trigger "notice", "post was published"
      else
        App.vent.trigger "error", 'post was not published.'


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
