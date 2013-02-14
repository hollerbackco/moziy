App.Views.CurrentSharing = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/current_sharing']

  events:
    "click #sharing-button": "share"

  initialize: ->
    _.bindAll this, "share"
    @listenTo App.vent, "airings:play", @show

  show: (airing) ->
    @model = airing
    @render()

  render: ->
    @$el.html @template @model.toJSON()

  share: ->
    App.vent.trigger "modals:share", @model
