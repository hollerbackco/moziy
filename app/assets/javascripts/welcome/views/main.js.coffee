WelcomeApp.Views.Main = Backbone.View.extend
  template: HandlebarsTemplates['welcome/templates/main']

  events:
    "click #next-button" : "next"

  initialize: ->
    @state = "add"

    @render()

    @addVideosView = new WelcomeApp.Views.AddVideos
      el: @$("#add-videos")

    @suggestFollowersView = new WelcomeApp.Views.SuggestChannels
      el: @$("#suggest-followers")
      model: WelcomeApp.exploreChannels

    @listenTo WelcomeApp.vent, "add:complete", @addComplete
    @listenTo WelcomeApp.vent, "follow:complete", @followComplete
    @listenTo WelcomeApp.vent, "follow:incomplete", @followIncomplete

    @$next = @$("#next").hide()

  addComplete: ->
    WelcomeApp.analytics.welcomeAddComplete()
    @showNext()

  followComplete: ->
    WelcomeApp.analytics.welcomeFollowComplete()
    @$next.find("h1").html ""
    @$next.find(".button").html "start watching"
    @showNext()

  followIncomplete: ->
    @hideNext()

  render: ->
    @$el.html @template()

  next: ->
    if @state == "add"
      @addVideosView.hide()
      @suggestFollowersView.show()
      @hideNext()
      @state = "follow"

    else
      window.location = "/"


  showNext: ->
    @$next.fadeIn(100)

  hideNext: ->
    @$next.hide()

