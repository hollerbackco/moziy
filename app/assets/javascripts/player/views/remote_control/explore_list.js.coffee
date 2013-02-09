App.Views.RemoteControlExploreList = Backbone.View.extend
  tagName: "ul"
  attributes:
    id: "explore-list"
    class: "clearfix"

  initialize: ->
    @subviews = []
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
          item =  new App.Views.RemoteControlExploreListItem
            model: channel
          @$el.append item.$el
          @subviews.push item

    this
