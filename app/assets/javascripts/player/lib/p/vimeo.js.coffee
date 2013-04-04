#= require player/lib/p/base_player

class App.VimeoPlayer extends App.Player
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
      current = @_player.api_getCurrentTime()
      duration = @_player.api_getDuration()
    {
      currentTime: current,
      totalTime: duration
    }

  _mute: ->
    @_player.api_setVolume(0) if @_player?
    super()

  _unMute: ->
    @_player.api_setVolume(1) if @_player?
    super()

  _play: ->
    @_player.api_play() if @_player?

  _pause: ->
    @_player.api_pause() if @_player?

  _stop: ->
    @_player.api_unload() if @_player?
    super()

  _hide: ->
    $("#vimeo-dummy").remove()
    $("##{@divId}").append("<div id='vimeo-dummy'></div>")
    @_player = undefined

  _show: ->
    $("##{@divId}").css 'display', 'block'

  _loadVideo: ->
    @_player.api_loadVideo @current_playing_id

  _onReady: =>
    Backbone.Events.trigger "player:ready"
    @_player = $("#vimeo-dummy")[0]
    @_mute unless @volumeState
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
      @_unMute()
