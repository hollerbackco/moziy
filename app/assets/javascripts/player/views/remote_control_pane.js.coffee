App.Views.RemoteControlPane = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/remote_control_pane']
  events:
    "click .menu-button" : "activateMenuItem"
    #"click .add"  : "showAdd"
    "click .login": "showLogin"
    "click .channels-modal": "showChannels"
    "click .help-modal": "showHelp"
    "click .invite": "showInvite"
    "click .remote-contro": "showInvite"

  initialize: ->
    @listenTo App.vent, "login", @login

    @$el.html "<h1 id=\"mosey\" class=\"invite\"><a href=\"http://www.moziy.com\">mosey</a></div>"

  render: ->
    @$el.html @template()

    @$el.hoverIntent
      over: =>
        App.analytics.vent.trigger "menu:open"
        @$el.addClass("hover")
        @channelListView.sort()
      sensitivity: 12
      timeout: 100
      out: =>
        @$el.removeClass("hover")
        @$(".dropdown").removeClass("open")

    @$(".dropdown-toggle").dropdown()

  showLogin: ->
    App.vent.trigger "modals:login"

  showChannels: ->
    App.vent.trigger "modals:channels"

  showHelp: ->
    App.vent.trigger "modals:multiimage"

  showAdd: ->
    App.vent.trigger "modals:add"

  showInvite: ->
    App.vent.trigger "modals:invite"

  activateMenuItem: (e) ->
    item = $ e.target
    @inactivateMenu()
    item.addClass "active"

  inactivateMenu: ->
    @$(".menu-button").removeClass "active"

  login: (user) ->
    @render()

    username = user.get "username"
    @$(".user .name").html username
    @$el.addClass "logged-in"

    @channelListView = new App.Views.RemoteControlChannelMenu
      el: @$("#remote-control-container")

