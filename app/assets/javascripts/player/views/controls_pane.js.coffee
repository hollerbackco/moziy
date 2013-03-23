App.Views.ControlsPane = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/controls_pane']
  events:
    "click #controls-right": "nextVideo"
    "click #controls-down": "pause"
    "click #controls-left": "fullscreen"

  initialize: ->
    @render()

  render: ->
    @$el.html @template()

    #@$el.hoverIntent
      #over: =>
      #sensitivity: 12
      #timeout: 100
      #out: =>
        #@$el.removeClass("hover")

    timer = 0

    $("body").mousemove =>
      if timer
        clearTimeout timer
        timer = 0
        @$el.show()
        @$el.addClass("hover")

      callback = =>
        if !@$el.is(":hover")
          @$el.fadeOut(200)
          #@$el.removeClass("hover")

      timer = setTimeout callback, 1000

    #@$(".dropdown-toggle").dropdown()

  fullscreen: ->
    App.vent.trigger "fullscreen"

  nextVideo: ->
    App.vent.trigger "player:next"
    mixpanel.track "Video:Skip"

  pause: ->
    App.vent.trigger "player:pause"
    mixpanel.track "Player:Pause"

