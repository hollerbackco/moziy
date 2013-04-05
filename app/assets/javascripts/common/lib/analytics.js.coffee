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
    "feed:watch":       "feedWatch"
    "channel:watch":    "channelWatch"
    "channel:follow":   "channelFollow"
    "user:signup":      "userSignup"
    "invite:request":   "inviteRequest"
    "fullscreen:open":  "fullscreenOpen"
    "fullscreen:close": "fullscreenClose"
    "welcome:add":             "welcomeAdd"
    "welcome:add:complete":    "welcomeAddComplete"
    "welcome:follow":          "welcomeFollow"
    "welcome:follow:complete": "welcomeFollowComplete"

  constructor: ->
    @_setupEvents @events

  whoToFollow: ->
    mixpanel.track "UI:Whotofollow"

  myChannels: ->
    mixpanel.track "UI:MyChannels"

  airingAdd: (airing) ->
    mixpanel.track "Add:Video"

  airingShare: (airing, shareType) ->
    mixpanel.track "Video:Share",
      slug: airing.get("channel").slug
      video: airing.get("title")
      share_type: shareType

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

  feedWatch: ->
    mixpanel.track "Feed:Watch"

  channelWatch: (channel) ->
    mixpanel.track "Channel:Watch",
      slug: channel.get("slug")
      id: channel.get("id")

  channelFollow: (channel) ->
    mixpanel.track "Channel:Follow",
      slug: channel.get("slug"),
      id: channel.get("id")

  userSignup: ->
    mixpanel.track "User:Signup"
    _gaq.push ['_trackEvent', 'User', 'Signup']

  inviteRequest: ->
    mixpanel.track "Invite:Request"
    _gaq.push ['_trackEvent', 'Invites', 'Request']

  playerPing: (airing, channel) ->
    _gaq.push ['_trackEvent', 'Videos', 'Watching', channel.get("slug")]
    mixpanel.people.increment
      "seconds watched": 10

  playerPlay: (airing, channel, isFeed=false) ->
    mixpanel.track "Video:Play",
      isFeed: isFeed
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

  welcomeAdd: ->
    mixpanel.track "Welcome:Add:Video"

  welcomeAddComplete: ->
    mixpanel.track "Welcome:Add:Complete"

  welcomeFollow: ->
    mixpanel.track "Welcome:Follow:Channel"

  welcomeFollowComplete: (callback) ->
    mixpanel.track "Welcome:Follow:Complete", callback

  _setupEvents: (events) ->
    _.each events, (method, key) =>
      method = this[method]
      if !method
        throw new Error('Method "' + events[key] + '" does not exist')
      @vent.on key, method, this

