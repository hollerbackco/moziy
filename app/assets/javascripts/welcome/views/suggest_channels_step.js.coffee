WelcomeApp.Views.SuggestChannelsStep = Backbone.View.extend
  template: HandlebarsTemplates['welcome/templates/suggest_channels_step']

  events:
    "click #next-button" : "next"

  initialize: ->
    @counter = 0
    @state = "follow"

    @listenTo WelcomeApp.vent, "channel:follow", @followOne
    @listenTo WelcomeApp.vent, "channel:unfollow", @unfollowOne

  render: ->
    @$el.html @template()

    @$next = @$("#next")
    @$nextMsg = @$("#next-message")
    @$nextBtn = @$("#next-button")

    @suggestChannelsList = new WelcomeApp.Views.SuggestChannelsList
      el: @$("#channel-list")
      model: WelcomeApp.exploreChannels

    @$(".pin-top-container").waypoint (direction) =>
      scroll =  $("body").scrollTop()
      if scroll? and scroll > 0
        if direction == "down"
          @$next.hide 0, =>
            @$el.addClass("pin-top-bar")
            @$next.fadeIn(200)
        if direction == "up"
          @$next.hide 0, =>
            @$el.removeClass("pin-top-bar")
            @$next.fadeIn(200)

    if WelcomeApp.config.followCount?
      @updateMessage "welcome. please follow 5 streams below"
      @$nextBtn.hide()

    @$el

  next: ->
    window.location = "/"

  hideNext: ->
    @$next.hide()

  followOne: ->
    @counter++

    WelcomeApp.analytics.welcomeFollow()

    if @counter > WelcomeApp.config.followCount - 1
      @onComplete()

    @updateMessage @message()

  unfollowOne: ->
    @counter--

    if @counter < WelcomeApp.config.followCount
      @onIncomplete()

    @updateMessage @message()

  _followsLeft: ->
    total = WelcomeApp.config.followCount || 0
    total - @counter

  message: ->
    "follow at least #{@_followsLeft()} more"

  onComplete: ->
    @state = "done"
    WelcomeApp.analytics.welcomeFollowComplete()
    @$next.find(".button").html "start watching"
    @$nextMsg.hide()
    @$nextBtn.show()

  onIncomplete: ->
    @state = "follow"
    @$nextMsg.show()
    @$nextBtn.hide()

  updateMessage: (msg) ->
    if @state != "done"
      @$nextMsg.addClass "blue"
      @$nextMsg.fadeOut 0, =>
        @$nextMsg.html(msg).fadeIn 100, =>
          @$nextMsg.removeClass "blue"
