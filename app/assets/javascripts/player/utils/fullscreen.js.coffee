class App.Fullscreen
  constructor: ->
    _.bindAll this, "updateStatus"
    @state = 0 #nonfullscreen
    @el = document.documentElement
    $(@el).bind 'webkitfullscreenchange mozfullscreenchange fullscreenchange', @updateStatus

  toggle: ->
    if @state
      @cancelFullscreen()
    else
      @goFullscreen(@el)

      mixpanel.track "Fullscreen"


  goFullscreen: (element) ->
    if(element.requestFullScreen)
      @state = 1
      element.requestFullScreen(element)
    else if(element.mozRequestFullScreen)
      @state = 1
      element.mozRequestFullScreen(element)
    else if(element.webkitRequestFullScreen)
      @state = 1
      App.disableHistory()
      element.webkitRequestFullScreen(element.AllOW_KEYBOARD_INPUT)

  cancelFullscreen: (element) ->
    if(document.cancelFullScreen)
      document.cancelFullScreen()
      @state = 0
    else if(document.mozCancelFullScreen)
      document.mozCancelFullScreen()
      @state = 0
    else if(document.webkitCancelFullScreen)
      document.webkitCancelFullScreen()
      App.enableHistory()
      @state = 0

  updateStatus: ->
    isFullScreen = document.fullscreen || document.mozFullScreen || document.webkitIsFullScreen || false

    if isFullScreen
      @state = 1
    else
      @cancelFullscreen()
