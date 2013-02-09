App.Views.RemoteControlChannelList = Backbone.View.extend
  tagName: "ul"

  attributes:
    class: "channels"

  subviews: []

  initialize: ->
    @$list = new infinity.ListView @$el
    @render()

  show: (@model) ->
    @render()

  clear: ->
    @$list.cleanup()
    @$el.html ""
    for view in @subviews
      view.remove()
    @subviews = []

  render: ->
    @model.fetch
      success: =>
        @model.each (channel) =>
          item =  new App.Views.RemoteControlChannelListItem
            model: channel
          @$list.append(item.$el)
          @subviews.push item
    this
