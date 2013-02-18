App.Views.RemoteControlExploreList = Backbone.View.extend
  tagName: "ul"

  attributes:
    id: "explore-list"
    class: "clearfix"

  initialize: ->
    _.bindAll this, "sort"
    @subviews = []


  show: (@model) ->
    @render()


  clear: ->
    @$el.html ""
    for view in @subviews
      view.remove()
    @subviews = []

  sort: ->
    @$el.isotope("reLayout")

  render: ->
    @clear()
    @model.fetch
      success: =>
        @model.each (channel) =>
          item =  new App.Views.RemoteControlExploreListItem
            model: channel
          @$el.append item.$el
          @subviews.push item

        @$el.isotope
          layoutMode: "masonry"
          itemSelector: "li"

    this
