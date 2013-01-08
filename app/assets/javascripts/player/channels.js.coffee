$ ->
  $.extend window.App,
    vent: _.extend {}, Backbone.Events

    initialize: (bootstrap) ->
      if bootstrap.current_user?
        @setupCurrentUser bootstrap.current_user

      @currentlyPlayingPane()
      @mainMenu()
      @muteButton()
      @setupModal()
      @setupHistory()
      @controller.initialize()

      @setupPlayer bootstrap.channel

    notice: (msg) ->
      $("#alert").html(msg).show().delay(2000).fadeOut(300)

    setupPlayer: (channel) ->
      @playerManager = new App.PlayerManager()
      App.vent.trigger "channel:watch", channel

    setupCurrentUser: (user) ->
      App.currentUser = new App.Models.CurrentUser(user)

    navigate: (href) ->
      Backbone.history.navigate(href)

    controller:
      initialize: ->
        App.vent.on "airing:like", @likeVideo
        App.vent.on "airing:restream", @restreamAiring

      likeVideo: (airing) ->
        alert_message = "You highfived #{airing.get('title')}"
        App.notice alert_message

        App.currentUser.like airing

      restreamAiring: (airing, channel) ->
        if App.currentUser?
          App.currentUser.restream airing, channel, (msg) ->
            App.notice msg


    setupHistory: ->
      Backbone.history.start
        pushState: true
        root: '/'
      App.vent.on "channel:watch", (channel) ->
        App.navigate "channels/#{channel.id}"


    muteButton: ->
      $("#mute").click ->
        $(this).toggleClass("on")
        App.playerManager.toggleMute()

    setupModal: ->
      App.modals =
        channel: new App.Views.ChannelModal(el: "#channel-modal")
        notes:   new App.Views.NotesModal(el: "#notes-modal")
        restream: new App.Views.RestreamModal(el: "#restream-modal")

    mainMenu: ->
      App.remoteControlPane = new App.Views.RemoteControlPane(el: "#remote-control-pane")
      $("#remote-control-pane").hoverIntent
        over: ->
          $(this).addClass("hover")
          $(".channels").show()
        sensitivity: 12
        timeout: 100
        out: ->
          $(this).removeClass("hover")
          $(".channels").hide()

    currentlyPlayingPane: ->
      App.currentAiringPane = new App.Views.CurrentAiring(el: "#current-video")
      App.currentChannelPane = new App.Views.CurrentChannel(el: "#current-channel")

      $("#current-pane-target-zone").hoverIntent
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
