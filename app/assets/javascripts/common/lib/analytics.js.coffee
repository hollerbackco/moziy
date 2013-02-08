class App.Analytics
  vent: _.extend {}, Backbone.Events

  events:
    "airing:like":      "airingLike"
    "airing:restream":  "airingRestream"
    "airing:add":       "airingAdd"
    "player:play":      "playerPlay"
    "player:ping":      "playerPing"
    "player:skip":      "playerSkip"
    "player:pause":     "playerPause"
    "player:unpause":   "playerUnpause"
    "channel:watch":    "channelWatch"
    "channel:follow":   "channelFollow"
    "fullscreen:open":  "fullscreenOpen"
    "fullscreen:close": "fullscreenClose"

  constructor: ->
    @_setupEvents @events

  airingAdd: (airing) ->
    mixpanel.track "Add:Video"

  airingLike: (airing) ->
    mixpanel.track "Video:Like"

  airingRestream: (airing) ->
    mixpanel.track "Video:Restream"

  channelWatch: (channel) ->
    mixpanel.track "Channel:Watch",
      slug: channel.get("slug"),
      id: channel.get("id"),

  channelFollow: (channel) ->
    mixpanel.track "Channel:Follow",
      slug: channel.get("slug"),
      id: channel.get("id"),

  playerPing: (airing, channel) ->
    _gaq.push ['_trackEvent', 'Videos', 'Watching', channel.get("slug")]

  playerPlay: (airing, channel) ->
    mixpanel.track "Video:Play"

  playerSkip: ->
    mixpanel.track "Video:Skip"

  playerPause: ->
    mixpanel.track "Player:Pause"

  playerUnpause: ->
    mixpanel.track "Player:Unpause"

  fullscreenOpen: ->
    mixpanel.track "Fullscreen:Open"

  fullscreenClose: ->
    mixpanel.track "Fullscreen:Close"

  _setupEvents: (events) ->
    _.each events, (method, key) =>
      method = this[method]
      if !method
        throw new Error('Method "' + events[key] + '" does not exist')
      @vent.on key, method, this

