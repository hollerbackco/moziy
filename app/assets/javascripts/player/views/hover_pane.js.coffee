class App.Views.HoverPane extends Backbone.View

  initialize: ->
    @sensitivity = @options.sensitivity
    @render()

  render: ->
    @el.hoverIntent
      over: =>
        @el.addClass("hover")
      sensitivity: @sensitivity
      timeout: 100
      out: =>
        @el.removeClass("hover")
