class App.PlayerManager
  constructor:  ->
    @volumeState = 1

    @vimeoPlayer = new App.VimeoPlayer('vimeo-player')
    @youtubePlayer = new App.YouTubePlayer('youtube-player')

    Backbone.Events.bind("player:finished", @next, this)
    Backbone.Events.bind("player:error", @errorPlayNext, this)
    App.vent.on("channel:watch", @changeChannel, this)
    App.vent.on("player:next", @next, this)

  changeChannel: (channel) ->
    @channel = channel
    @channel.getFirstAiring (airing) =>
      @next_video = airing
      @next()

  next: =>
    @_play @next_video

  errorPlayNext: (msg) =>
    App.controller.notice "Couldn't play #{@getCurrentVideoTitle()}. Moving on."
    @_play @next_video

  toggleMute: ->
    if @volumeState
      @volumeState = 0
      Backbone.Events.trigger("player:mute")
    else
      @volumeState = 1
      Backbone.Events.trigger("player:unMute")

  getCurrentAiring: ->
    @current_video

  getCurrentChannelID: ->
    @channel.id

  getCurrentVideoID: ->
    @current_video.id

  getCurrentVideoTitle: ->
    @current_video.get "title"

  _isNew: (video) ->
    @next_video.id != video.id

  _playFromId: (id) ->
    @channel.getAiringFromID id, (airing) =>
      @_play airing

  _play: (airing) =>
    # set the current video
    @current_video = airing
    video = airing.toJSON()

    try
      switch video.source_name
        when 'youtube'
          @_playerPlay @youtubePlayer, video

        when 'vimeo'
          @_playerPlay @vimeoPlayer, video

        else
          console.log "queue next"
          @_queue @next
    catch error
      @next()

  _playerPlay: (player, video) ->
    @_stopPlayers()

    player.play video.source_id

    @_setNowPlaying video.title
    @_notifyPlayers()

    # queue up the next next video
    @_queue()

  _stopPlayers: ->
    Backbone.Events.trigger("player:stop")

  _notifyPlayers: ->
    App.vent.trigger "airings:play", @current_video
    Backbone.Events.trigger("player:update")

    @channel.watchAiring()

  _setNowPlaying: (title) ->

    $("#video-title").text title

  _queue: (callback) ->
    self = this

    @channel.getNextAiring @next_video, (airing) ->
      self._shiftQueue(airing)
      callback() if callback?

  _shiftQueue: (airing) ->
    @next_video = airing
    App.cookie.set("channel-#{@channel.id}", @next_video.id, 14)
