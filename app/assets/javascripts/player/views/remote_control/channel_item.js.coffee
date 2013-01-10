App.Views.RemoteControlChannelListItem = Backbone.View.extend
  tagName: "li"
  className: "channel clearfix"
  template: HandlebarsTemplates['player/templates/channel_list_item']

  events:
    "click": "watch"

  initialize: ->
    @render()

  render: ->
    @$el.html @template @model.toJSON()
    if App.currentUser?
      @$el.addClass("following") if App.currentUser.isFollowing(@model)

  watch: ->
    App.vent.trigger "channel:watch", @model

  remove: ->
    @$el.remove()
