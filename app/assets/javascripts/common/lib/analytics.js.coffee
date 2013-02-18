class App.Analytics
  vent: _.extend {}, Backbone.Events

  events:
    "ui:whotofollow":   "whoToFollow"
    "ui:mychannels":    "myChannels"
    "airing:like":      "airingLike"
    "airing:restream":  "airingRestream"
    "airing:add":       "airingAdd"
    "airing:share":     "airingShare"
    "player:play":      "playerPlay"
    "player:ping":      "playerPing"
    "player:skip":      "playerSkip"
    "player:pause":     "playerPause"
    "player:unpause":   "playerUnpause"
    "channel:watch":    "channelWatch"
    "channel:follow":   "channelFollow"
    "invite:request":   "inviteRequest"
    "fullscreen:open":  "fullscreenOpen"
    "fullscreen:close": "fullscreenClose"

  constructor: ->
    @_setupEvents @events

  whoToFollow: ->
    mixpanel.track "UI:Whotofollow"

  myChannels: ->
    mixpanel.track "UI:MyChannels"

  airingAdd: (airing) ->
    mixpanel.track "Add:Video"

  airingShare: (airing) ->
    mixpanel.track "Video:Share",
      slug: airing.get("channel").slug
      video: airing.get("title")

  airingLike: (airing) ->
    mixpanel.track "Video:Like",
      slug: airing.get("channel").slug
      video: airing.get("title")
      provider: airing.get("source_name")
      provider_id: airing.get("source_id")
      note_count: airing.get("note_count")

  airingRestream: (airing) ->
    mixpanel.track "Video:Restream",
      slug: airing.get("channel").slug
      video: airing.get("title")
      provider: airing.get("source_name")
      provider_id: airing.get("source_id")
      note_count: airing.get("note_count")

  channelWatch: (channel) ->
    mixpanel.track "Channel:Watch",
      slug: channel.get("slug"),
      id: channel.get("id")

  channelFollow: (channel) ->
    mixpanel.track "Channel:Follow",
      slug: channel.get("slug"),
      id: channel.get("id")

  inviteRequest: ->
    mixpanel.track "Invite:Request"
    _gaq.push ['_trackEvent', 'Invites', 'Request']

  playerPing: (airing, channel) ->
    _gaq.push ['_trackEvent', 'Videos', 'Watching', channel.get("slug")]
    mixpanel.people.increment
      "seconds watched": 10

  playerPlay: (airing, channel) ->
    mixpanel.track "Video:Play",
      slug: channel.get("slug")
      video: airing.get("title")
      provider: airing.get("source_name")
      provider_id: airing.get("source_id")
      note_count: airing.get("note_count")

    mixpanel.people.increment
      "videos watched": 1

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

