if typeof(window.App) == "undefined" then window.App = {}

class App.PlayerManager
  youtubePlayer: new App.YouTubePlayer('youtube-player')  
  vimeoPlayer: new App.VimeoPlayer('vimeo-player')

  constructor: (@starting_video_id, @channel_id) ->
    @_playFromId @starting_video_id
    @volumeState = 1
    Backbone.Events.bind("player:finished", @next, this)
    Backbone.Events.bind("player:error", @errorPlayNext, this)

  next: =>
    # todo: what happens if the queue fails
    @_play @next_video

  errorPlayNext: (msg) =>
    window.App.notice "Couldn't play #{@getCurrentVideoTitle()}. Moving on."
    @_play @next_video

  toggleMute: ->
    if @volumeState
      @volumeState = 0
      Backbone.Events.trigger("player:mute")
    else
      @volumeState = 1
      Backbone.Events.trigger("player:unMute")

  getCurrentChannelID: ->
    @channel_id

  getCurrentVideoID: ->
    @current_video.id

  getCurrentVideoTitle: ->
    @current_video.title

  _isNew: (video) ->
    @next_video.id != video.id

  _playFromId: (id) ->
    self = this
    $.ajax
      url: "/channels/#{@channel_id}/videos/#{id}",
      success: (video) ->
        self.current_video = video
        self._play video

  _play: (video) =>
    # set the current video

    @current_video = video

    try
      switch video.source_name
        when 'youtube'
          @youtubePlayer.play(video.source_id)

          # set the title
          @_setNowPlaying video.title

          # hide or show the right players
          @_notifyPlayers()

          # queue up the next next video
          @_queue()

        when 'vimeo' 
          @vimeoPlayer.play(video.source_id)

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
    Backbone.Events.trigger("player:update")

  _setNowPlaying: (title) ->
    $("#video-title").text title

  _queue: (callback) ->

    self = this

    $.ajax
      url: "/channels/#{@channel_id}/videos/#{@current_video.id}/next",
      success: (video) ->
        self._shiftQueue(video)
        callback() if callback?

  _shiftQueue: (video) ->
    @next_video = video
    window.App.cookie.set("channel-#{@channel_id}", video.id, 14)
