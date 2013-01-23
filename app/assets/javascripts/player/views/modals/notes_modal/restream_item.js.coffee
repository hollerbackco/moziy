App.Views.RestreamItem = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/notes_modal/restream_item']
  className: "restream-item clearfix"

  events:
    "click"         : "moreInfo"
    "click .follow" : "follow"

  initialize: ->
    _.bindAll this, "moreInfo"
    @render()

  render: ->
    @$el.html @template @model.toJSON()

  moreInfo: ->
    App.vent.trigger "modals:channel", @model

  remove: ->
    @$el.remove()

  follow: ->
