class App.PlayerManager
  constructor:  ->
    _.bindAll(this, '_play')
    @volumeState = 1
    @playState = 1 #0 is paused

    @vimeoPlayer = new App.VimeoPlayer('vimeo-player')
    @youtubePlayer = new App.YouTubePlayer('youtube-player')

    Backbone.Events.bind("player:finished", @next, this)
    Backbone.Events.bind("player:error", @errorPlayNext, this)
    App.vent.on("channel:watch", @changeChannel, this)
    App.vent.on("player:next", @next, this)
    App.vent.on("player:pause", @togglePause, this)


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
      @playState = 0
      Backbone.Events.trigger("player:pause")
    else
      @playState = 1
      Backbone.Events.trigger("player:play")

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

  _playerPlay: (player, airing) ->
    @_stopPlayers()
    player.play airing.get "source_id"
    @_notifyPlayers airing

    @playState = 1
    mixpanel.track "Video:Play"

  _stopPlayers: ->
    Backbone.Events.trigger("player:stop")

  _notifyPlayers: (airing) ->
    App.vent.trigger "airings:play", airing, @channel
    Backbone.Events.trigger("player:update")
