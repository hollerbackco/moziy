class App.Keyboard
  constructor: ->
    @render()

  render: ->
    $("html").keydown (e) =>
      @register e, 27, =>
        @_modalsClose()

      if ! @_formFocus e
        @register e, 38, =>
          @_toggleFullscreen()

        @register e, 110, =>
          @_nextVideo()

        @register e, 20, =>
          @_togglePause()

        @register e, 39, =>
          @_nextVideo()

        @register e, 77, =>
          @_toggleMute()

        @register e, 40, =>
          @_togglePause()


  register: (e, key, callback) ->
    if e.which == key
      callback()

  _modalsClose: ->
    App.vent.trigger "modals:close"

  _formFocus: (e) ->
    currentFocus = $( document.activeElement )
    currentFocus.is("input,textarea,select,button")

  _nextVideo: ->
    App.vent.trigger "player:next"
    mixpanel.track "Video:Skip"

  _toggleMute: ->
    App.vent.trigger "player:mute"

  _togglePause: ->
    App.vent.trigger "player:pause"


  _toggleFullscreen: ->
    App.vent.trigger "fullscreen"
