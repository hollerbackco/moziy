App.Views.CurrentChannel = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/current_channel']
  events:
    "click .follow-button" : "follow"
    "click .edit"   : "edit"

  initialize: ->
    _.bindAll this, "follow", "edit", "show"
    @listenTo App.vent, "channel:watch", @show

  show: (channel) ->
    @model = channel
    @render()

  render: ->
    @$el.html @template @model.toJSON()

  follow: ->
    App.vent.trigger "channel:follow", @model

  edit: ->