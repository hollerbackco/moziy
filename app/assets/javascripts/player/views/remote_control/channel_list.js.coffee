App.Views.RemoteControlChannelList = Backbone.View.extend
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
    console.log @$el
    @clear()
    @model.each (channel) =>
      item =  new App.Views.RemoteControlChannelListItem
        model: channel
      @$el.append item.$el
      @subviews.push item
