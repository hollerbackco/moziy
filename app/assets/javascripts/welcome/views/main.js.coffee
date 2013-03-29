WelcomeApp.Views.Main = Backbone.View.extend
  template: HandlebarsTemplates['welcome/templates/main']

  events:
    "click #next-button" : "next"

  initialize: ->
    @state = "follow"

    @render()

    if WelcomeApp.config.followCount?
      @listenTo WelcomeApp.vent, "follow:complete", @followComplete
      @listenTo WelcomeApp.vent, "follow:incomplete", @followIncomplete
      @listenTo WelcomeApp.vent, "next:message", @updateMessage
      @updateMessage "welcome. please follow five streams below"
      @$nextBtn.hide()


  addComplete: ->
    WelcomeApp.analytics.welcomeAddComplete()
    @showNext()

  followComplete: ->
    @state = "done"
    WelcomeApp.analytics.welcomeFollowComplete()
    @$next.find(".button").html "start watching"
    @$nextMsg.hide()
    @$nextBtn.show()

  followIncomplete: ->
    @state = "follow"
    @$nextMsg.show()
    @$nextBtn.hide()

  updateMessage: (msg) ->
    if @state != "done"
      @$nextMsg.addClass "blue"
      @$nextMsg.fadeOut 0, =>
        @$nextMsg.html(msg).fadeIn 100, =>
          @$nextMsg.removeClass "blue"

  render: ->
    @$el.html @template()

    @$next = @$("#next")
    @$nextMsg = @$("#next-message")
    @$nextBtn = @$("#next-button")

    @suggestFollowersView = new WelcomeApp.Views.SuggestChannels
      el: @$("#suggest-followers")
      model: WelcomeApp.exploreChannels

    @$(".pin-top-container").waypoint (direction) =>
      if direction == "down"
        @$next.hide 0, =>
          @$el.addClass("pin-top-bar")
          @$next.fadeIn(200)
      if direction == "up"
        @$next.hide 0, =>
          @$el.removeClass("pin-top-bar")
          @$next.fadeIn(200)

  next: ->
    window.location = "/"

  showNext: ->
    @$next.fadeIn(100)
    @$nextBtn.fadeIn(100)

  hideNext: ->
    @$next.hide()

