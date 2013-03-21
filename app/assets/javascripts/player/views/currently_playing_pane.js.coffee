App.Views.CurrentlyPlayingPane = Backbone.View.extend
  initialize: ->
    if App.currentUser.loggedIn()
      @currentAiringPane = new App.Views.CurrentAiring(el: @$("#current-video"))
      #@currentChannelPane = new App.Views.CurrentChannel(el: @$("#current-channel"))
    else
      @currentSharingPane = new App.Views.CurrentSharing(el: @$("#current-sharing"))

    App.vent.on "channel:watch", @updateMark, this

  updateMark: (channel) ->
    @$(".mark img").attr "src", channel.get("cover_art").thumb_list.url
