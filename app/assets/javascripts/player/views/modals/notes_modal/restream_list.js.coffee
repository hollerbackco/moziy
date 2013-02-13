App.Views.RestreamList = Backbone.View.extend
  subviews: []

  initialize: ->

  clear: () ->
    @_clear()

  # should be a collection
  refresh: (restreams) ->
    @_clear()

    for obj in restreams
      restream = new App.Models.Channel(obj.channel)
      subview = new App.Views.RestreamItem(model: restream, type: obj.type, body: obj.body)
      @_add subview

  _clear: ->
    for i in @subviews
      i.remove()
    @subviews = []

  _add: (subview) ->
    @$el.append subview.$el
    @subviews.push subview
