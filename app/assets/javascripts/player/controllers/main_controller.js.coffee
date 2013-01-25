class App.Controllers.MainController
  constructor: ->
    self = this
    _.bindAll this, "likeVideo", "restreamAiring", "followChannel", "notice", "addAiring"

    App.vent.on "airing:like", @likeVideo
    App.vent.on "airing:restream", @restreamAiring
    App.vent.on "channel:follow", @followChannel
    App.vent.on "airing:add", @addAiring
    App.vent.on "player:mute", @mute, this
    App.vent.on "modals:restream", @showRestreamModal, this
    App.vent.on "modals:login", @showLoginModal, this
    App.vent.on "modals:add", @showAddModal, this

    $("#mute").click ->
      $(this).toggleClass("on")
      self.mute()

  notice: (msg) ->
    $("#alert").html(msg).show().delay(2000).fadeOut(300)

  showAddModal: ->
    @authenticate App.modals.add.show

  showRestreamModal: ->
    @authenticate App.modals.restream.show

  showLoginModal: ->
    App.modals.login.show()

  followChannel: (channel) ->
    @authenticate ->
      @notice "Followed #{channel.get 'title'}"

      App.currentUser.follow(channel).done (results) ->
        channel.set("channel_subscribers_count", results.count)

  likeVideo: (airing) ->
    @authenticate ->
      alert_message = "You liked <div>#{airing.get('title')}</div>"
      @notice alert_message
      App.currentUser.like airing

  restreamAiring: (airing, channel) ->
    if App.currentUser?
      App.currentUser.restream airing, channel, (msg) =>
        @notice msg

  addAiring: (airings) ->
    titleDivs = _.map airings, (airing) ->
      "<div>#{airing.title}</div>"
    if airings.length > 0
      @notice "Added #{titleDivs.join()}"
    else
      @notice "<div>Error adding</div>"

  mute: ->
    @notice "muted"
    App.playerManager.toggleMute()

  authenticate: (callback) ->
    if App.currentUser.loggedIn()
      callback()
    else
      @showLoginModal()


