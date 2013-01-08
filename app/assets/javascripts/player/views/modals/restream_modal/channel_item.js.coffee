App.Views.RestreamModalChannelItem = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/restream_modal/channel_item']
  events:
    "click": "restream"

  initialize: ->
    _.bindAll this, "restream"
    @render()

  render: ->
    @$el.html @template @model.toJSON()
    console.log @$el

  restream: ->
    @trigger "restream", @model
