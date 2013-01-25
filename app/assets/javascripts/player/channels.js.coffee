$ ->
  $.extend window.App,
    vent: _.extend {}, Backbone.Events

    initialize: (bootstrap) ->
      current_user = if bootstrap.current_user? then bootstrap.current_user else {loggedIn:false}
      App.currentUser = new App.Models.CurrentUser current_user

      if bootstrap.channels?
        App.exploreChannels = bootstrap.channels

      @setupTitleChanger()
      @setupViews()
      @setupHistory()
      @setupKeyboard()

      App.controller = new App.Controllers.MainController()

      if App.currentUser? and App.currentUser.loggedIn()
        App.vent.trigger "login", App.currentUser
      else
        @setupInvite()

      @setupPlayer bootstrap.channel, bootstrap.first_airing_id

    navigate: (href, replace=false) ->
      Backbone.history.navigate(href, {replace: replace})

    setupKeyboard: ->
      App.keyboard = new App.Keyboard()

    setupTitleChanger: ->
      App.vent.on "channel:watch", (channel) ->
        $("title").html("#{channel.get "slug"} | moziy")

    setupHistory: ->
      Backbone.history.start
        pushState: true
        root: '/'
      App.vent.on "channel:watch", (channel) ->
        App.navigate "#{channel.get "slug"}"
      App.vent.on "airings:play", (airing, channel) ->
        App.navigate "#{channel.get "slug"}/video?v=#{airing.id}", true

    setupViews: ->
      App.currentlyPlayingPane = new App.Views.CurrentlyPlayingPane
        el: "#current-pane-target-zone"

      App.remoteControlPane = new App.Views.RemoteControlPane(el: "#remote-control-pane")

      App.modals =
        channel:  new App.Views.ChannelModal(el: "#channel-modal")
        notes:    new App.Views.NotesModal(el: "#notes-modal")
        restream: new App.Views.RestreamModal(el: "#restream-modal")
        add:      new App.Views.AddModal(el: "#add-modal")
        login:    new App.Views.LoginModal(el: "#login-modal")
        invite:   new App.Views.InviteModal(el: "#invite-modal")

    setupInvite: ->
      App.invitePane = new App.Views.InvitePane()
      $("body").append(App.invitePane.el)

    setupPlayer: (channel, airing_id) ->
      @playerManager = new App.PlayerManager()
      App.vent.trigger "channel:watch", channel, airing_id
