class App.Controllers.MainController
  constructor: ->
    self = this
    _.bindAll this, "notice", "addAiring"

    App.vent.on "airing:add", @addAiring, this
    App.vent.on "airing:like", @likeVideo, this
    App.vent.on "airing:restream", @restreamAiring, this
    App.vent.on "airings:play", @playVideo, this
    App.vent.on "feed:watch", @feedWatch, this
    App.vent.on "channel:watch", @channelWatch, this
    App.vent.on "channel:follow", @channelFollow, this
    App.vent.on "invite:request", @requestInvite, this
    App.vent.on "player:mute", @playerMute, this
    App.vent.on "player:next", @playerNext, this
    App.vent.on "player:pause", @playerTogglePause, this
    App.vent.on "modals:channels", @showChannelsModal, this
    App.vent.on "modals:restream", @showRestreamModal, this
    App.vent.on "modals:share", @showSharingModal, this
    App.vent.on "modals:login", @showLoginModal, this
    App.vent.on "modals:add", @showAddModal, this
    App.vent.on "modals:invite", @showInviteModal, this
    App.vent.on "notice", @notice, this
    App.vent.on "error", @showError, this
    App.vent.on "fullscreen", @fullscreen, this

    $("#mute").click ->
      $(this).toggleClass("on")
      self.mute()

  notice: (msg) ->
    $("#alert").html(msg).show().delay(2000).fadeOut(300)

  fullscreen: ->
    App.fullscreen.toggle()

  feedWatch: ->
    App.analytics.vent.trigger "feed:watch"

  channelWatch: (channel) ->
    App.analytics.vent.trigger "channel:watch", channel


  playVideo: (airing, channel, isFeed=false) ->
    App.analytics.vent.trigger "player:play", airing, channel, isFeed

  channelFollow: (channel) ->
    @authenticate =>
      App.currentUser.follow(channel).done (results) ->
        channel.set("channel_subscribers_count", results.count)

      App.analytics.vent.trigger "channel:follow", channel

  showAddModal: ->
    @authenticate App.modals.add.show

  showRestreamModal: (airing) ->
    @authenticate =>
      App.modals.restream.show(airing)

  showChannelsModal: ->
    @authenticate =>
      App.modals.channels.show()

  showSharingModal: (airing) ->
    App.modals.sharing.show airing

  showLoginModal: ->
    App.modals.login.show()

  showInviteModal: ->
    App.modals.invite.show()

  requestInvite: (email,opts={}) ->
    post = $.ajax
      url: "/invites.json"
      type: "POST"
      data:
        email: email

    post.done (results) =>
      if results.success
        opts.success() if opts.success?
      else
        opts.error(results.errors) if opts.error?

    post.fail =>
      @fivehundred()

  likeVideo: (airing) ->
    @authenticate =>
      alert_message = "liked <div>#{airing.get('title')}</div>"
      @notice alert_message

      App.currentUser.like airing
      App.analytics.vent.trigger "airing:like", airing

  restreamAiring: (airing, channel) ->
    if App.currentUser?
      App.currentUser.restream airing, channel, (msg) =>
        @notice msg
        App.analytics.vent.trigger "airing:restream", airing

  addAiring: (msg) ->
    titleDivs = "<div>#{msg}</div>"
    @notice "Added #{titleDivs}"
    App.analytics.vent.trigger "airing:add", airing

  playerNext: ->
    App.analytics.vent.trigger "player:skip", App.playerManager.airing
    App.playerManager.next()

  playerTogglePause: ->
    if App.playerManager.togglePause()
      App.analytics.vent.trigger "player:unpause"
    else
      App.analytics.vent.trigger "player:pause"

  playerMute: ->
    App.playerManager.toggleMute()

  authenticate: (callback) ->
    if App.currentUser.loggedIn()
      callback()
    else
      @showInviteModal()

  fivehundred: ->
    @notice "Something went wrong"

  showError: (msg) ->
    @notice msg
