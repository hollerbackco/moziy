App.Views.ModalChannelItem = Backbone.View.extend
  className: "channel-item"
  template: HandlebarsTemplates['player/templates/restream_modal/channel_item']
  events:
    "click": "click"

  initialize: ->
    _.bindAll this, "click"
    if @options.template?
      @template = @options.template
    @render()

  render: ->
    @$el.html @template @model.toJSON()

  click: ->
    @trigger "click", @model
