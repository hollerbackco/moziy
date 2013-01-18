App.Views.CurrentAiring = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/current_airing']

  events:
    "click .like" : "like"
    "click .restream" : "restream"
    "click #video-notes" : "notes"
    "click .restream-from" : "showRestreamFrom"

  initialize: ->
    _.bindAll this, "like", "restream", "show"
    @listenTo App.vent, "airings:play", @show

  show: (airing) ->
    @model = airing
    @render()

  render: ->
    @$el.html @template @model.toJSON()

  notes: ->
    App.vent.trigger "airing:notes", @model

  like: ->
    App.vent.trigger "airing:like", @model

  restream: ->
    # this should have a controller
    App.vent.trigger "modals:restream", @model

  showRestreamFrom: (e) ->
    e.preventDefault()
    channel = new App.Models.Channel @model.get("parent").channel
    App.vent.trigger "modals:channel", channel
