WelcomeApp.Views.SuggestChannelsStep = Backbone.View.extend
  template: HandlebarsTemplates['welcome/templates/suggest_channels_step']

  events:
    "click #next-button" : "next"

  initialize: ->
    @counter = 0
    @state = "follow"

  render: ->
    @$el.html @template()

    @$next = @$("#next")
    @$nextMsg = @$("#next-message")
    @$nextBtn = @$("#next-button")

    @suggestChannelsList = new WelcomeApp.Views.SuggestChannelsList
      el: @$(".welcome-channel-list")

    _.each WelcomeApp.exploreChannels, (value, key) =>
      @suggestChannelsList.append value, key

    @listenTo @suggestChannelsList, "channel:follow", @followOne
    @listenTo @suggestChannelsList, "channel:unfollow", @unfollowOne

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

    if WelcomeApp.config.followCount? and WelcomeApp.config.followCount > 0
      @updateMessage "welcome. please follow #{WelcomeApp.config.followCount} streams below"
      @$nextBtn.hide()

    @$el

  next: ->
    WelcomeApp.vent.trigger "wizard:next"

  hideNext: ->
    @$next.hide()

  followOne: ->
    @counter++

    WelcomeApp.analytics.welcomeFollow()

    if @counter > WelcomeApp.config.followCount - 1
      @onComplete()
      @updateMessage ""
    else
      @updateMessage @message()

  unfollowOne: ->
    @counter--

    if @counter < WelcomeApp.config.followCount
      @onIncomplete()
      @updateMessage @message()
    else
      @updateMessage ""

  _followsLeft: ->
    total = WelcomeApp.config.followCount || 0
    total - @counter

  message: ->
    "follow at least #{@_followsLeft()} more"

  onComplete: ->
    @state = "done"
    WelcomeApp.analytics.welcomeFollowComplete()
    @$nextMsg.hide()
    @$nextBtn.css("display", "inline-block")

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
