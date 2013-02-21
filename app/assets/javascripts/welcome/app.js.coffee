window.WelcomeApp =
  Views: {}
  Controllers: {}
  Models: {}

$ ->
  $.extend window.WelcomeApp,
    vent: _.extend {}, Backbone.Events

    initialize: (bootstrap) ->
      @currentUser = new App.Models.CurrentUser bootstrap.currentUser
      @exploreChannels = new App.Models.Channels bootstrap.exploreChannels
      @setupViews()
      @setupAnalytics()

      WelcomeApp.vent.on "channel:follow", @follow, this

    setupViews: ->
      @views =
        main: new WelcomeApp.Views.Main(el: $(".container"))

    setupAnalytics: ->
      WelcomeApp.analytics = new App.Analytics()

    follow: (channel) ->
      @currentUser.follow channel

