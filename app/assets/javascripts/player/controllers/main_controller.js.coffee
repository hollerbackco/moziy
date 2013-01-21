class App.Controllers.MainController
  constructor: ->
    self = this
    App.vent.on "airing:like", @likeVideo
    App.vent.on "airing:restream", @restreamAiring
    App.vent.on "channel:follow", @followChannel

    $("#mute").click ->
      $(this).toggleClass("on")
      self.mute()

  notice: (msg) ->
    $("#alert").html(msg).show().delay(2000).fadeOut(300)

  followChannel: (channel) ->
    @notice "Followed #{channel.get 'title'}"
    App.currentUser.follow channel

  likeVideo: (airing) ->
    alert_message = "You liked <div>#{airing.get('title')}</div>"
    @notice alert_message

    App.currentUser.like airing

  restreamAiring: (airing, channel) ->
    if App.currentUser?
      App.currentUser.restream airing, channel, (msg) =>
        @notice msg

  mute: ->
    App.playerManager.toggleMute()
