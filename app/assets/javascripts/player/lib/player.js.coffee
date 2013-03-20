class App.PlayerManager
  constructor:  ->
    _.bindAll(this, '_play', '_playerPing')

    @volumeState = 1
    @playState = 1 #0 is paused

    @vimeoPlayer = new App.VimeoPlayer('vimeo-player')
    @youtubePlayer = new App.YouTubePlayer('youtube-player')

    Backbone.Events.bind("player:finished", @next, this)
    Backbone.Events.bind("player:error", @errorPlayNext, this)

    App.vent.on("channel:watch", @watchChannel, this)
    App.vent.on("feed:watch", @watchFeed, this)

  watchFeed: ->
    @stream = new App.FeedStreamer()
    @stream.start().done @_play

  watchChannel: (channel, airing_id=null) ->
    @stream = new App.SingleStreamer channel
    @stream.start(airing_id).done @_play

  next: ->
    @_play @stream.next()

  errorPlayNext: (msg) =>
    App.controller.notice "Couldn't play #{@getCurrentVideoTitle()}. Moving on."
    @next()

  togglePause: ->
    if @playState
      Backbone.Events.trigger "player:pause"
      @_stop()
    else
      @player._play() if @player?
      @_go()

  toggleMute: ->
    if @volumeState
      @volumeState = 0
      Backbone.Events.trigger("player:mute")
    else
      @volumeState = 1
      Backbone.Events.trigger("player:unMute")

  getCurrentAiring: ->
    @stream.current.airing

  getCurrentChannelID: ->
    @stream.current.channel.id

  getCurrentVideoID: ->
    @stream.current.channel.id

  getCurrentVideoTitle: ->
    @stream.current.channel.get "title"

  _play: (obj) ->
    console.log obj.airing
    airing = obj.airing
    channel = obj.channel
    try
      switch airing.get "source_name"
        when 'youtube'
          @_playerPlay @youtubePlayer, airing

        when 'vimeo'
          @_playerPlay @vimeoPlayer, airing

        else
          @next()

    catch error
      console.log "error"
      @next()

  _playerPlay: (@player, @airing) ->
    @_stop()
    @_stopPlayers()
    @player.play @airing.get "source_id"
    @_notifyPlayers @airing
    @_go()

  _stop: ->
    @playState = 0
    clearInterval @timer

  _go: ->
    @playState = 1
    @timer = setInterval @_playerPing, 10000

  _playerPing: ->
    App.analytics.vent.trigger "player:ping", @airing, @stream.current.channel

  _stopPlayers: ->
    Backbone.Events.trigger("player:stop")

  _notifyPlayers: (airing) ->
    App.vent.trigger "airings:play", airing, @stream.current.channel
    Backbone.Events.trigger("player:update")
