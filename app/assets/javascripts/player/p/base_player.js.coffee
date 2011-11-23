if typeof(window.App) == "undefined" then window.App = {}

class App.Player
  # @state
    # 0 = stopped
    # 1 = playing
  constructor: ->
    @state = 0 #stopped
    @volumeState = 1

  update: ->
    if @state
      @_show()
    else
      @_hide()
    
  _mute: ->
    @volumeState = 0
     
  _unMute: ->
    @volumeState = 1
    
  play: (video_id) ->
    @state = 1
    @current_playing_id = video_id

    unless @_player?
      @_bootstrap()
    else
      @_loadVideo()

  error: (error) ->
    alert error

  _hide: =>
    $("##{@divId}").css 'display', 'none'

  _show: =>
    $("##{@divId}").css 'display', 'block'

  _onError: (event) ->
    @error(event)
    Backbone.Events.trigger('player:error')
    
  _onEnd: ->
    @state = 0
    Backbone.Events.trigger('player:finished')

  #_onReady: =>
  #_bootstrap: ->
