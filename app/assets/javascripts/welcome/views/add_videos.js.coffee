WelcomeApp.Views.AddVideos = Backbone.View.extend
  template: HandlebarsTemplates['welcome/templates/add_videos']

  events:
    "submit" : "add"

  initialize: ->
    @render()
    @$form = @$("form")
    @$links = @$("input[name=links]")
    @$button = @$(".button.primary")
    @action = "/me/channels/#{WelcomeApp.currentUser.get "primary_channel_id"}/videos"

    @addVideoListView = new WelcomeApp.Views.AddVideoList
      el: @$("#video-list")

    @counter = 0

  add: (e) ->
    e.preventDefault()

    urls = @$links.val()

    if urls? and urls != ""
      @_loading()

      deferred = @_doEmbedly urls

      deferred.done (videos) =>
        sending_video = new App.Models.Video()

        toServer = sending_video.create(@action, urls, false)

        toServer.done (state, msg) =>
          @counter++
          @_clearForm()
          @_ready()

          for video in videos
            @addVideoListView.append video
            WelcomeApp.analytics.welcomeAdd()

          if @counter > 2
            WelcomeApp.vent.trigger "add:complete"

      deferred.fail (msg) =>
        alert msg

    else
      alert "please add a url"


  _doEmbedly: (urls) ->
    fromEmbedly = $.embedly.oembed urls,
      key: "584b1c340e4811e186fe4040d3dc5c07"

    fromEmbedly.pipe (results) ->
      _.map results, (result) ->
        video = new App.Models.Video
          title: result.title
          image_url: result.thumbnail_url


  render: ->
    @$el.html @template()

  hide: ->
    @$el.fadeOut(100)

  show: ->
    @$el.fadeIn(500)

  _clearForm: ->
     @$links.val ""

  _loading: ->
    @$form.addClass "loading"
    @$button.attr "disabled", "disabled"

  _ready: ->
    @$form.removeClass "loading"
    @$button.removeAttr "disabled"

