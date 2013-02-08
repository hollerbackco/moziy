class App.PlayerManager
  constructor:  ->
    _.bindAll(this, '_play', '_playerPing')
    @volumeState = 1
    @playState = 1 #0 is paused

    @vimeoPlayer = new App.VimeoPlayer('vimeo-player')
    @youtubePlayer = new App.YouTubePlayer('youtube-player')

    Backbone.Events.bind("player:finished", @next, this)
    Backbone.Events.bind("player:error", @errorPlayNext, this)

    App.vent.on("channel:watch", @changeChannel, this)

  changeChannel: (channel, airing_id) ->
    @channel = channel
    @channel.startWatching(airing_id).done @_play

  next: ->
    @_play @channel.watchNext()

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
    @channel.watching

  getCurrentChannelID: ->
    @channel.id

  getCurrentVideoID: ->
    @channel.watching.id

  getCurrentVideoTitle: ->
    @channel.watching.get "title"

  _play: (airing) ->
    try
      switch airing.get "source_name"
        when 'youtube'
          @_playerPlay @youtubePlayer, airing

        when 'vimeo'
          @_playerPlay @vimeoPlayer, airing

        else
          @next()
    catch error
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
    App.analytics.vent.trigger "player:ping", @player.getInfo(), @airing, @channel

  _stopPlayers: ->
    Backbone.Events.trigger("player:stop")

  _notifyPlayers: (airing) ->
    App.vent.trigger "airings:play", airing, @channel
    Backbone.Events.trigger("player:update")
