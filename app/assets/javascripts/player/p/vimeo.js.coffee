if typeof(window.App) == "undefined" then window.App = {}

class App.VimeoPlayer
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
    $("#vimeo-dummy").remove()
    $("##{@divId}").append("<div id='vimeo-dummy'></div>")
    @_player = undefined

  _show: ->
    $("##{@divId}").css 'display', 'block'

  play: (video_id) ->
    @state = 1
    @current_playing_id = video_id

    unless @_player?
      @_bootstrap()
    else
      @_player.api_loadVideo @current_playing_id

  error: (error) ->
    alert error

  _onError: (event) ->
    @error(event)

  _onEnd: ->
    @state = 0
    App.playerManager.next()

  _onReady: =>
    @_player = $("#vimeo-dummy")[0]
    @_player.api_addEventListener 'onFinish', "function(){App.playerManager.vimeoPlayer._onEnd()}"
    

  _bootstrap: ->
    params = 
      allowScriptAccess: "always"
      wmode: "transparent"
      
    flashvars =
      clip_id: @current_playing_id
      color: "000000"
      portrait: 0
      autoplay: 1
      byline: 0
      title: 0
      fullscreen: 0
      api: 1 #required in order to use the Javascript API
      api_ready: 'onVimeoPlayerLoaded'
    
    swfobject.embedSWF("http://vimeo.com/moogaloop.swf", "vimeo-dummy", "100%", "100%", "9.0.0",null, flashvars, params)

    window.onVimeoPlayerLoaded = =>
      @_onReady()
      