if typeof(window.App) == "undefined" then window.App = {}

class App.YouTubePlayer
  # @state
    # 0 = stopped
    # 1 = playing
  constructor: (@divId) ->
    @state = 0 #stopped
  
  update: ->
    if @state
      @_show()
    else
      @_hide()
      
  _hide: ->
    $("##{@divId}").css 'display', 'none'
      
  _show: ->
    $("##{@divId}").css 'display', 'block'
    
  play: (video_id) ->
    @state = 1
    @current_playing_id = video_id
    
    unless @_player?
      @_bootstrap()
    else
      @_player.loadVideoById @current_playing_id

  error: (error) ->
    alert error
  
  _onStateChange: (event) =>
    switch event.data
      when 0 #YT.PlayerState.ENDED
        @_onEnd()
        break
      when 1 then break #YT.PlayerState.PLAYING
      when 3 then break #YT.PlayerState.BUFFERING
      when 5 then break #YT.PlayerState.CUED
      else
        break
  _onError: (event) ->
    @error(event)

  _onEnd: ->
    @state = 0
    App.playerManager.next()
  
  _onReady: ->
    
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