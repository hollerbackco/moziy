App.Views.ControlsPane = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/controls_pane']
  events:
    "click #controls-right": "nextVideo"
    "click #controls-down": "pause"

  initialize: ->
    @render()

  render: ->
    @$el.html @template()

    @$el.hoverIntent
      over: =>
        @$el.addClass("hover")
      sensitivity: 12
      timeout: 100
      out: =>
        @$el.removeClass("hover")

    @$(".dropdown-toggle").dropdown()

  nextVideo: ->
    App.vent.trigger "player:next"
    mixpanel.track "Video:Skip"

  pause: ->
    App.vent.trigger "player:pause"
    mixpanel.track "Player:Pause"

