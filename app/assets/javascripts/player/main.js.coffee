$ ->
  $.extend window.App,
    vent: _.extend {}, Backbone.Events

    initialize: (bootstrap) ->
      current_user = if bootstrap.current_user? then bootstrap.current_user else {loggedIn:false}

      channel = if bootstrap.channel?
        new App.Models.Channel bootstrap.channel
      else
        null

      App.currentUser = new App.Models.CurrentUser current_user

      @setupTitleChanger()
      @setupViews()
      @setupAnalytics()
      @setupHistory()
      @setupFullscreen()
      @setupKeyboard()

      App.controller = new App.Controllers.MainController()
      @setupPlayer channel, bootstrap.first_airing_id

      if App.currentUser? and App.currentUser.loggedIn()
        App.vent.trigger "login", App.currentUser
      else
        if bootstrap.noInvite? and bootstrap.noInvite
        else
          @setupInvite()
          App.modals.invite.show()
          Backbone.Events.on "player:ready", =>
            App.vent.trigger "player:pause"
            Backbone.Events.off "player:ready"


      if bootstrap.showWelcome? and bootstrap.showWelcome
        App.modals.multiImage.show()
        Backbone.Events.on "player:ready", =>
          App.vent.trigger "player:pause"
          Backbone.Events.off "player:ready"

    navigate: (href, replace=false) ->
      if @navigateEnabled
        Backbone.history.navigate(href, {replace: replace})
      else
        App.savedUrl = href

    setupExplore: (explore) ->
      App.exploreChannels = new App.Models.Channels(explore)
      App.exploreChannels.url = "/channels.json"

    setupAnalytics: ->
      App.analytics = new App.Analytics()

    setupFullscreen: ->
      App.fullscreen = new App.Fullscreen()

    setupKeyboard: ->
      App.keyboard = new App.Keyboard()

    setupTitleChanger: ->
      App.vent.on "channel:watch", (channel) ->
        $("title").html("#{channel.get "slug"} | moziy")

    disableHistory: ->
      @navigateEnabled = false

    enableHistory: ->
      @navigateEnabled = true
      if App.savedUrl?
        App.navigate App.savedUrl, true

    setupHistory: ->
      @navigateEnabled = true

      Backbone.history.start
        pushState: true
        root: '/'

      App.vent.on "channel:watch", (channel) ->
        App.navigate "#{channel.get "slug"}"

      App.vent.on "airings:play", (airing, channel, isFeed=false) ->
        if isFeed
          App.navigate "f/#{airing.get "channel_slug"}/video?v=#{airing.id}", true
        else
          App.navigate "#{channel.get "slug"}/video?v=#{airing.id}", true

    setupViews: ->
      App.currentlyPlayingPane = new App.Views.CurrentlyPlayingPane
        el: "#current-pane-target-zone"

      App.remoteControlPane = new App.Views.RemoteControlPane(el: "#remote-control-pane")

      App.controlsPane = new App.Views.ControlsPane(el: "#controls-pane")

      #App.actionsPane = new App.Views.ActionsPane(el: "#actions-pane")

      App.modals =
        channel:  new App.Views.ChannelModal(el: "#channel-modal")
        notes:    new App.Views.NotesModal(el: "#notes-modal")
        restream: new App.Views.RestreamModal(el: "#restream-modal")
        sharing:  new App.Views.SharingModal(el: "#sharing-modal")
        add:      new App.Views.AddModal(el: "#add-modal")
        login:    new App.Views.LoginModal(el: "#login-modal")
        invite:   new App.Views.InviteModal(el: "#invite-modal")
        channels:   new App.Views.ChannelListModal(el: "#channels-modal")
        image:   new App.Views.ImageModal(el: "#image-modal")

      App.modals.multiImage = new App.Views.MultiimageModal
        el: "#multiimage-modal",
        title: "welcome. moziy is a nonstop feed of videos curated by streams you follow."
        images: [
          "/assets/player/welcome/1.gif"
          "/assets/player/welcome/2.gif"
          "/assets/player/welcome/3.gif"
          "/assets/player/welcome/4.gif"
          "/assets/player/welcome/5.gif"
          "/assets/player/welcome/6.gif"
        ]


    setupInvite: ->
      App.invitePane = new App.Views.InvitePane()
      $("body").append(App.invitePane.el)

    setupPlayer: (channel, airing_id) ->
      @playerManager = new App.PlayerManager()

      if channel?
        App.vent.trigger "channel:watch", channel, airing_id
      else
        App.vent.trigger "feed:watch", airing_id
