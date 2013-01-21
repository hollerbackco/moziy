App.Views.RemoteControlPane = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/remote_control_pane']
  events:
    "click .menu-button" : "activateMenuItem"
    "click .add"  : "showAdd"
    "click .home" : "showHome"
    "click .explore" : "showExplore"
    "click .me" : "showMe"
    "click .login": "showLogin"

  initialize: ->
    @homeChannels = App.currentUser.channelList || App.exploreChannels || (new App.Models.Channels())
    @exploreChannels = App.exploreChannels
    @myChannels = App.currentUser.channels

    @render()
    @showHome()

    @listenTo App.vent, "login", @login

  render: ->
    @$el.html @template()

    @$el.hoverIntent
      over: =>
        @$el.addClass("hover")
      sensitivity: 12
      timeout: 100
      out: =>
        @$el.removeClass("hover")
        @$(".dropdown").removeClass("open")

    @$(".dropdown-toggle").dropdown()

    @channelListView = new App.Views.RemoteControlChannelList
      model: @homeChannels
      el: @$(".channels")

  showLogin: ->
    App.vent.trigger "modals:login"

  showAdd: ->
    App.vent.trigger "modals:add"

  showHome: ->
    @channelListView.show @homeChannels

  showExplore: ->
    @channelListView.show @exploreChannels

  showMe: ->
    @channelListView.show @myChannels

  activateMenuItem: (e) ->
    item = $ e.target
    @inactivateMenu()
    item.addClass "active"

  inactivateMenu: ->
    @$(".menu-button").removeClass "active"

  login: (user) ->
    username = user.get "username"
    @$(".user .name").html username
    @$el.addClass "logged-in"
