

class YouTubePlayer
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
      @_player.loadVideoById @current_playing_id

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
    
  onAPIReady: ->
    @_player = new YT.Player @divId, {
      height: '100%',
      width: '100%',
      videoId: @current_playing_id,
      playerVars: 
        'rel': 0,
        'controls': 0,
        'disablekb': 1, 
        'enablejsapi': 1,
        'wmode': 'transparent',
        'autoplay': 1,
        'showinfo': 0,
        'modestbranding': 1,
        'origin': window.location.host
      events:
        'onReady': @_onReady,
        'onStateChange': @_onStateChange,
        'onError': @_onError
    }
  
  _bootstrap: ->
    tag = document.createElement('script')
    tag.src = "http://www.youtube.com/player_api"
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag

window.onYouTubePlayerAPIReady = ->
  App.playerManager.youtubePlayer.onAPIReady()
  

class VimeoPlayer
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
      

class window.PlayerManager
  youtubePlayer: new YouTubePlayer('youtube-player')  
  vimeoPlayer: new VimeoPlayer('vimeo-player')

  constructor: (@starting_video_id, @channel_id) ->
    @_playFromId @starting_video_id


  next: ->
    # todo: what happens if the queue fails
    @_play @next_video

  
  _isNew: (video) ->
    @next_video.id != video.id
  
  _playFromId: (id) ->
    self = this
    $.ajax
      url: "/channels/#{@channel_id}/videos/#{id}",
      success: (video) ->
        self.current_video = video
        self._play video
        
    
  _play: (video) ->
    # set the current video
    @current_video = video
    self = this
    
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
          
        #when 'vimeo' then @vimeoPlayer.play(video.source_id)
        else @queue self.next
    catch error
      @queue self.next
      
  _notifyPlayers: ->
    @youtubePlayer.update()
    @vimeoPlayer.update()
  
  _setNowPlaying: (title) ->
    $("#video-title").text title
    
  _queue: (callback) ->
    
    self = this
    
    $.ajax
      url: "/channels/#{@channel_id}/videos/#{@current_video.id}/next",
      success: (video) ->
        self._shiftQueue(video)
        callback()
    
  _shiftQueue: (video) ->
    @next_video = video
    window.App.cookie.set("channel-#{@channel_id}", video.id, 14)
