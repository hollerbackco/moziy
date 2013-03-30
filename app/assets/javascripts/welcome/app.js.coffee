window.WelcomeApp =
  Views: {}
  Controllers: {}
  Models: {}

$ ->
  $.extend window.WelcomeApp,
    vent: _.extend {}, Backbone.Events

    initialize: (bootstrap) ->
      @setupConfig bootstrap.config
      @setupAnalytics()
      @currentUser = new App.Models.CurrentUser bootstrap.currentUser
      @exploreChannels = new App.Models.Channels bootstrap.exploreChannels
      @setupViews()

      WelcomeApp.vent.on "channel:follow", @follow, this
      WelcomeApp.vent.on "channel:unfollow", @follow, this

    setupConfig: (options = {}) ->
      @config = options

    setupAnalytics: ->
      WelcomeApp.analytics = new App.Analytics()

    setupViews: ->

      wizard = new WelcomeApp.Views.Wizard( el: $(".container") )

      wizard.registerStep(new WelcomeApp.Views.SuggestChannelsStep())

      wizard.start()




    follow: (channel) ->
      @currentUser.follow channel
