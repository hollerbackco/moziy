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

    setupViews: ->
      @views =
        main: new WelcomeApp.Views.Main(el: $(".container"))

    setupConfig: (options = {}) ->
      @config = options

    setupAnalytics: ->
      WelcomeApp.analytics = new App.Analytics()

    follow: (channel) ->
      @currentUser.follow channel
