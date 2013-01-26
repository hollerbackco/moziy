App.Views.RestreamItem = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/notes_modal/restream_item']
  className: "restream-item clearfix"

  events:
    "click"         : "moreInfo"
    "click .follow" : "follow"

  initialize: ->
    _.bindAll this, "moreInfo"
    @type = @options.type
    @render()

  render: ->
    json = _.extend @model.toJSON(),
      restream: (@type == "Restream")
      like: (@type == "Like")
      add: (@type == "Add")

    @$el.html @template json

  moreInfo: ->
    App.vent.trigger "modals:channel", @model

  remove: ->
    @$el.remove()

  follow: ->
