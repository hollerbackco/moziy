WelcomeApp.Views.SuggestChannels = Backbone.View.extend
  template: HandlebarsTemplates['welcome/templates/suggest_channels']

  initialize: ->
    @counter = 0

    @render()

    @suggestChannelsList = new WelcomeApp.Views.SuggestChannelsList
      el: @$("#channel-list")
      model: @model

    if WelcomeApp.config.followCount?
      @listenTo WelcomeApp.vent, "channel:follow", @addOne
      @listenTo WelcomeApp.vent, "channel:unfollow", @removeOne

  render: ->
    @$el.html @template()

  hide: ->
    @$el.fadeOut(100)

  show: ->
    @$el.fadeIn(500)

  addOne: ->
    @counter++

    WelcomeApp.analytics.welcomeFollow()

    if @counter > WelcomeApp.config.followCount - 1
      WelcomeApp.vent.trigger "follow:complete"

    WelcomeApp.vent.trigger "next:message", @message()

  removeOne: ->
    @counter--

    if @counter < WelcomeApp.config.followCount
      WelcomeApp.vent.trigger "follow:incomplete"

    WelcomeApp.vent.trigger "next:message", @message()

  followsLeft: ->
    total = WelcomeApp.config.followCount || 0
    total - @counter

  message: ->
    "follow at least #{@followsLeft()} more"
