App.Views.CurrentlyPlayingPane = Backbone.View.extend
  initialize: ->
    @currentAiringPane = new App.Views.CurrentAiring(el: @$("#current-video"))
    @currentChannelPane = new App.Views.CurrentChannel(el: @$("#current-channel"))

    @$el.hoverIntent
      over: ->
        $(this).addClass("hover")
        $("#current-pane").show()
        $(".mark", this).hide()
      sensitivity: 15
      timeout: 100
      out: ->
        $(this).removeClass("hover")
        $("#current-pane").hide()
        $(".mark", this).show()

    App.vent.on "channel:watch", @updateMark, this

  updateMark: (channel) ->
    @$(".mark img").attr "src", channel.get("cover_art").thumb_list_url
