App.Views.SharingModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/sharing_modal']
  events:
    "click #share-facebook": "shareFb"
    "click #share-twitter": "shareTw"

  initialize: ->
    _.bindAll this, "show", "close", "_success"

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
      link: @_airingUrl()

    FB.ui obj, (response) =>
      if response and response.post_id
        App.analytics.vent.trigger "airing:share", @model
        App.vent.trigger "notice", "post was published"
      else
        App.vent.trigger "error", 'Post was not published.'

  _success: ->
    @$("form").addClass "submitted"
    App.analytics.vent.trigger "airings:share"

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
