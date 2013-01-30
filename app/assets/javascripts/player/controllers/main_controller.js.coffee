class App.Controllers.MainController
  constructor: ->
    self = this
    _.bindAll this, "likeVideo", "restreamAiring", "followChannel", "notice", "addAiring"

    App.vent.on "airing:like", @likeVideo
    App.vent.on "airing:restream", @restreamAiring
    App.vent.on "channel:watch", @watchChannel, this
    App.vent.on "channel:follow", @followChannel
    App.vent.on "airing:add", @addAiring
    App.vent.on "invite:request", @requestInvite, this
    App.vent.on "player:mute", @mute, this
    App.vent.on "modals:restream", @showRestreamModal, this
    App.vent.on "modals:login", @showLoginModal, this
    App.vent.on "modals:add", @showAddModal, this
    App.vent.on "modals:invite", @showInviteModal, this

    $("#mute").click ->
      $(this).toggleClass("on")
      self.mute()

  notice: (msg) ->
    $("#alert").html(msg).show().delay(2000).fadeOut(300)

  watchChannel: (channel) ->
    mixpanel.track "Channel:Watch",
      slug: channel.get("slug"),
      id: channel.get("id"),

  showAddModal: ->
    @authenticate App.modals.add.show

  showRestreamModal: (airing) ->
    @authenticate =>
      App.modals.restream.show(airing)

  showLoginModal: ->
    App.modals.login.show()

  showInviteModal: ->
    App.modals.invite.show()

  requestInvite: (email,opts={}) ->
    post = $.ajax
      url: "/invite"
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

  followChannel: (channel) ->
    @authenticate =>
      App.currentUser.follow(channel).done (results) ->
        channel.set("channel_subscribers_count", results.count)

      mixpanel.track "Channel:Follow",
        slug: channel.get("slug"),
        id: channel.get("id"),

  likeVideo: (airing) ->
    @authenticate =>
      alert_message = "You liked <div>#{airing.get('title')}</div>"
      @notice alert_message
      App.currentUser.like airing

      mixpanel.track "Video:Like"

  restreamAiring: (airing, channel) ->
    if App.currentUser?
      App.currentUser.restream airing, channel, (msg) =>
        @notice msg
        mixpanel.track "Video:Restream"

  addAiring: (airings) ->
    titleDivs = _.map airings, (airing) ->
      "<div>#{airing.title}</div>"
    if airings.length > 0
      @notice "Added #{titleDivs.join()}"

      mixpanel.track "Add:Video"
    else
      @notice "<div>Error adding</div>"

  mute: ->
    App.playerManager.toggleMute()

  authenticate: (callback) ->
    if App.currentUser.loggedIn()
      callback()
    else
      @showLoginModal()

  fivehundred: ->
    @notice "Something went wrong"

