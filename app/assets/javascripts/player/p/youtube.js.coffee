if typeof(window.App) == "undefined" then window.App = {}

class App.YouTubePlayer extends App.Player
  # @state
    # 0 = stopped
    # 1 = playing
  constructor: (@divId) ->
    Backbone.Events.bind("player:update", @update, this)
    Backbone.Events.bind("player:mute", @_mute, this)
    Backbone.Events.bind("player:unMute", @_unMute, this)
    super()

  _loadVideo: ->
    @_player.loadVideoById @current_playing_id
  
  _onStateChange: (event) =>
    switch event.data
      when 0 #YT.PlayerState.ENDED
        @_onEnd()
      when 1 then break #YT.PlayerState.PLAYING
      when 2 #YT.PlayerState.PAUSED
        @_onPause()
      when 3 then break #YT.PlayerState.BUFFERING
      when 5 then break #YT.PlayerState.CUED

  
  _onPause: ->
    @_player.playVideo() if @_player?
    
  _unMute: ->
    @_player.unMute() if @_player?
    super()
    
  _mute: ->
    @_player.mute() if @_player?
    super()
    
  _onReady: =>
    @_player.mute() unless @volumeState
    
  onAPIReady: ->
    @_player = new YT.Player @divId, {
      height: '100%',
      width: '100%',
      videoId: @current_playing_id,
      playerVars: 
        'rel': 0,
        'controls': 0,
        'disablekb': 1, 
        'enablejsapi': 1,
        'wmode': 'transparent',
        'autoplay': 1,
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
    tag.src = "http://www.youtube.com/player_api"
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag

window.onYouTubePlayerAPIReady = ->
  App.playerManager.youtubePlayer.onAPIReady()