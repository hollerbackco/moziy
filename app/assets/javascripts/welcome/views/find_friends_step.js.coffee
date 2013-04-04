#todo
# - loader while the js window is open
# - loader while getting the contacts

WelcomeApp.Views.FindFriendsStep = Backbone.View.extend
  template: HandlebarsTemplates['welcome/templates/find_friends_step']

  initialize: ->
    _.bindAll this, "gmail", "openJsWindow"
    @render()

    @listenTo WelcomeApp.vent, "gmail:connect", @gmail

  events:
    "click #next-button":  "next"
    "click .cancel":       "reset"

  render: ->
    @$el.html @template()

    @$connectButton = @$(".from-gmail")
    @$authenticatingLoader = @$("#connect-gmail-loader").hide()
    @$findingLoader = @$("#finding-friends-loader").hide()

    @$el

  next: ->
    WelcomeApp.vent.trigger "wizard:next"

  reset: ->
    clearTimeout @polling
    if WelcomeApp.jsWindow?
      WelcomeApp.jsWindow.close()
      WelcomeApp.jsWindow = null
    @$authenticatingLoader.hide()
    @$findingLoader.hide()
    @$connectButton.show()

  gmail: ->
    WelcomeApp.currentUser.checkGmail().done (isAuthorized) =>
      if isAuthorized
        @$authenticatingLoader.hide()
        @$findingLoader.show()
        @$connectButton.hide()

        if WelcomeApp.jsWindow?
          WelcomeApp.jsWindow.close()
          WelcomeApp.jsWindow = null

        @getContacts()
      else
        @$authenticatingLoader.show()
        @$connectButton.hide()

        @polling = setTimeout @gmail, 1000

  getContacts: ->
    promise = WelcomeApp.currentUser.getGmailContacts()

    promise.done (channels) =>
      @$findingLoader.hide()
      if channels.length > 0
        @showChannels channels, @$(".welcome-channel-list").hide()
      else
        @$("#find-friends").append "<p>it looks like you're the first to join moziy. invite your friends!</p>"

  openJsWindow: ->
    url    = "/auth/google_oauth2"

    WelcomeApp.jsWindow = window.open(url)

    false

  showChannels: (channels, el) ->
    @channelsList = new WelcomeApp.Views.SuggestChannelsList
      el: el
      model: channels
      withEmail: true
    el.fadeIn(500)
