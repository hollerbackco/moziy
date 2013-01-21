App.Views.CurrentlyPlayingPane = Backbone.View.extend
  initialize: ->
    @currentAiringPane = new App.Views.CurrentAiring(el: @$("#current-video"))
    @currentChannelPane = new App.Views.CurrentChannel(el: @$("#current-channel"))

    @$el.hoverIntent
      over: ->
        $(this).addClass("hover")
        $("#current-pane").show()
        $(".mark", this).hide()
      sensitivity: 14
      timeout: 100
      out: ->
        $(this).removeClass("hover")
        $("#current-pane").hide()
        $(".mark", this).show()
