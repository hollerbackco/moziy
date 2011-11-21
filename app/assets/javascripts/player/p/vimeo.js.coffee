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
    $("##{@divId}").css 'display', 'none'

  _show: ->
    $("##{@divId}").css 'display', 'block'

  play: (video_id) ->
    @state = 1
    @current_playing_id = video_id

    unless @_player?
      @_bootstrap()
    else
      @_player.api 'loadVideo', @current_playing_id

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
    alert 'hello'
  onAPIReady: ->
    src = "http://player.vimeo.com/video/#{@current_playing_id}?" +
      "title=0&" +
      "byline=0&" +
      "portrait=0&" +
      "color=000000&" +
      "autoplay=1&" +
      "api=1"

    player = $('<iframe>').attr('src', src)
      .attr('height', '100%')
      .attr('width', '100%')
      .attr('frameborder', 0)
      .load ->
        self._player = $f(this)
        self._player.addEvent('ready', self._onReady)
        self._player.addEvent('finish', self._onEnd)
        
    $("##{@divId}").append(player)

  _bootstrap: ->
    tag = document.createElement('script')
    tag.src = "/assets/vimeo.min.js"
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag

window.onVimeoPlayerAPIReady = ->
  App.playerManager.vimeoPlayer.onAPIReady()