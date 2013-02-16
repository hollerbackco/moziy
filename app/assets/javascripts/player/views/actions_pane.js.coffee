App.Views.ActionsPane = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/actions_pane']

  events:
    "click .like" : "like"
    "click .restream" : "restream"

  initialize: ->
    _.bindAll this, "like", "restream", "update"
    @listenTo App.vent, "airings:play", @update

    @render()

  update: (airing) ->
    @model = airing

  render: ->
    @$el.html @template()
    timer = 0

    $("#player .mask").mousemove =>
      if timer
        clearTimeout timer
        timer = 0
        @$el.show()
        @$el.addClass("hover")

      callback = =>
        if !@$el.is(":hover")
          @$el.fadeOut(200)
          @$el.removeClass("hover")

      timer = setTimeout callback, 500


  like: ->
    App.vent.trigger "airing:like", @model

  restream: ->
    # this should have a controller
    App.vent.trigger "modals:restream", @model
