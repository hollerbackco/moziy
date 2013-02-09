App.Views.RemoteControlChannelList = Backbone.View.extend
  tagName: "ul"

  attributes:
    class: "channels"

  subviews: []

  initialize: ->
    @render()

  show: (@model) ->
    @render()

  clear: ->
    @$el.html ""
    for view in @subviews
      view.remove()
    @subviews = []

  render: ->
    @clear()
    @model.fetch
      success: =>
        @model.each (channel) =>
          item =  new App.Views.RemoteControlChannelListItem
            model: channel
          @$el.append item.$el
          @subviews.push item
    this
