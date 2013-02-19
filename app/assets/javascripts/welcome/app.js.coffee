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

      WelcomeApp.vent.on "channel:follow", @follow, this

    setupViews: ->
      @views =
        main: new WelcomeApp.Views.Main(el: $(".container"))

    follow: (channel) ->
      @currentUser.follow channel

