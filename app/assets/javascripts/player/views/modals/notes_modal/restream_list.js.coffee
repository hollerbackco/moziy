App.Views.RestreamList = Backbone.View.extend

  subviews: []

  initialize: ->

  # should be a collection
  refresh: (restreams) ->

    @_clear()

    for obj in restreams
      restream = new App.Models.Channel(obj)
      subview = new App.Views.RestreamItem(model: restream)
      @_add subview

  _clear: ->
    for i in @subviews
      @subviews[i].remove()
    @subviews = []

  _add: (subview) ->
    @$el.append subview.$el
    @subviews.push subview
