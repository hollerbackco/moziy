WelcomeApp.Views.SuggestChannels = Backbone.View.extend
  template: HandlebarsTemplates['welcome/templates/suggest_channels']

  initialize: ->
    @counter = 0

    @render()

    @suggestChannelsList = new WelcomeApp.Views.SuggestChannelsList
      el: @$("#channel-list")
      model: @model

    #@$el.hide()

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

    if @counter > 2
      WelcomeApp.vent.trigger "follow:complete"


  removeOne: ->
    @counter--

    if @counter < 3
      WelcomeApp.vent.trigger "follow:incomplete"
