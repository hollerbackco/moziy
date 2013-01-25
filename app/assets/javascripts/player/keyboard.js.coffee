class App.Keyboard
  constructor: ->
    @render()

  render: ->
    $("html").keydown (e) =>

      @register e, 110, =>
        @_nextVideo()

      @register e, 39, =>
        @_nextVideo()

      @register e, 77, =>
        @_toggleMute()

  register: (e, key, callback) ->
    if e.which == key
      callback()

  _nextVideo: ->
    App.vent.trigger "player:next"

  _toggleMute: ->
    App.vent.trigger "player:mute"
