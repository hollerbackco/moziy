#= require player/lib/p/base_player

class App.YouTubePlayer extends App.Player
  # @state
    # 0 = stopped
    # 1 = playing
  constructor: (@divId) ->
    Backbone.Events.on("player:update", @update, this)
    Backbone.Events.on("player:mute", @_mute, this)
    Backbone.Events.on("player:unMute", @_unMute, this)
    Backbone.Events.on("player:stop", @_stop, this)
    Backbone.Events.on("player:play", @_play, this)
    Backbone.Events.on("player:pause", @_pause, this)
    super()

  getInfo: ->
    if @_player?
      current = @_player.getCurrentTime()
      duration = @_player.getDuration()
    {
      currentTime: current,
      totalTime: duration
    }

  _loadVideo: ->
    @_player.loadVideoById @current_playing_id

  _onStateChange: (event) =>
    switch event.data
      when 0 #YT.PlayerState.ENDED
        @_onEnd()
      when 1 then break #YT.PlayerState.PLAYING
      when 2 then break #YT.PlayerState.PAUSED
       # @_onPause()
      when 3 then break #YT.PlayerState.BUFFERING
      when 5 then break #YT.PlayerState.CUED

  _unMute: ->
    @_player.unMute() if @_player?
    super()

  _mute: ->
    @_player.mute() if @_player?
    super()

  _pause: ->
    @_player.pauseVideo() if @_player?

  _play: ->
    @_player.playVideo() if @_player?

  _stop: ->
    @_player.stopVideo() if @_player?
    @_player.clearVideo() if @_player?
    super()

  _onReady: =>
    Backbone.Events.trigger "player:ready"
    if @volumeState
      @_player.unMute()
    else
      @_player.mute()

  onAPIReady: ->
    @_player = new YT.Player @divId, {
      height: '100%',
      width: '100%',
      videoId: @current_playing_id,
      playerVars:
        'rel': 0,
        'controls': 0,
        'autoplay': 1,
        'disablekb': 1,
        'enablejsapi': 1,
        'showinfo': 0,
        'modestbranding': 1,
        'fs': 0,
        'origin': window.location.host
      events:
        'onReady': @_onReady,
        'onStateChange': @_onStateChange,
        'onError': @_onError
    }

  _bootstrap: ->
    tag = document.createElement('script')
    tag.src = "//www.youtube.com/player_api"
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag

    window.onYouTubePlayerAPIReady = =>
      App.playerManager.youtubePlayer.onAPIReady()
