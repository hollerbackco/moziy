class App.PlayerManager
  youtubePlayer: new App.YouTubePlayer('youtube-player')
  vimeoPlayer: new App.VimeoPlayer('vimeo-player')
  constructor:  ->
    @volumeState = 1

    Backbone.Events.bind("player:finished", @next, this)
    Backbone.Events.bind("player:error", @errorPlayNext, this)
    App.vent.on("channel:watch", @changeChannel, this)

  changeChannel: (channel) ->
    @channel = channel
    @channel.getFirstAiring @_play

  next: =>
    # todo: what happens if the queue fails
    @_play @next_video

  errorPlayNext: (msg) =>
    App.notice "Couldn't play #{@getCurrentVideoTitle()}. Moving on."
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
    self = this
    @channel.getAiringFromID id, (airing) ->
      self._play airing

  _play: (airing) =>
    # set the current video

    @current_video = airing

    video = airing.toJSON()

    try
      switch video.source_name
        when 'youtube'
          @youtubePlayer.play video.source_id

          # set the title
          @_setNowPlaying video.title

          # hide or show the right players
          @_notifyPlayers()

          # queue up the next next video
          @_queue()

        when 'vimeo'
          @vimeoPlayer.play video.source_id

          # set the title
          @_setNowPlaying video.title

          # hide or show the right players
          @_notifyPlayers()

          # queue up the next next video
          @_queue()

        else @_queue @next
    catch error
      @next()


  _notifyPlayers: ->
    App.vent.trigger "airings:play", @current_video
    Backbone.Events.trigger("player:update")

  _setNowPlaying: (title) ->
    $("#video-title").text title

  _queue: (callback) ->
    self = this

    @channel.getNextAiring @current_video, (airing) ->
      self._shiftQueue(airing)
      callback() if callback?


  _shiftQueue: (airing) ->
    @next_video = airing
    App.cookie.set("channel-#{@channel.id}", @next_video.id, 14)
