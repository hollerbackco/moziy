App.Views.CurrentAiring = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/current_airing']

  events:
    "click .like" : "like"
    "click .restream" : "restream"
    "click #video-notes" : "notes"
    "click .share-link" : "share"
    "click .channel-from" : "showChannelFrom"
    "click #video-parent img" : "showChannelFrom"
    "click .restream-from" : "showRestreamFrom"

  initialize: ->
    _.bindAll this, "like", "restream", "show", "share"
    @listenTo App.vent, "airings:play", @show

  show: (airing) ->
    @model = airing
    @render()

  render: ->
    @$el.html @template @model.toJSON()
    @currentSharingPane = new App.Views.CurrentSharing
      el: @$("#video-share")
      model: @model

    if @model.get "liked"
      @$(".like").addClass "on"
    else
      @$(".like").removeClass "on"

  notes: ->
    App.vent.trigger "airing:notes", @model

  share: ->
    App.vent.trigger "modals:share", @model

  like: ->
    App.vent.trigger "airing:like", @model
    @$(".like").addClass "on"

  restream: ->
    # this should have a controller
    App.vent.trigger "modals:restream", @model
    @$(".restream").addClass "on"

  showChannelFrom: (e) ->
    e.preventDefault()
    channel = new App.Models.Channel @model.get("channel")
    App.vent.trigger "modals:channel", channel

  showRestreamFrom: (e) ->
    e.preventDefault()
    channel = new App.Models.Channel @model.get("parent")
    App.vent.trigger "modals:channel", channel
