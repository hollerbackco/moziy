#todo
# - loader while the js window is open
# - loader while getting the contacts

WelcomeApp.Views.FindFriendsStep = Backbone.View.extend
  template: HandlebarsTemplates['welcome/templates/find_friends_step']

  initialize: ->
    _.bindAll this, "gmail", "openJsWindow"
    @render()

  events:
    "click #next-button":  "next"
    "click .from-gmail":   "gmail"
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
    if @jsWindow?
      @jsWindow.close()
      @jsWindow = null
    @$authenticatingLoader.hide()
    @$findingLoader.hide()
    @$connectButton.show()

  gmail: ->
    WelcomeApp.currentUser.checkGmail().done (isAuthorized) =>
      if isAuthorized
        @$authenticatingLoader.hide()
        @$findingLoader.show()
        @$connectButton.hide()

        if @jsWindow?
          @jsWindow.close()
          @jsWindow = null

        @getContacts()
      else
        if !@jsWindow?
          @openJsWindow()
        @$authenticatingLoader.show()
        @$connectButton.hide()

        @polling = setTimeout @gmail, 1000

  getContacts: ->
    promise = WelcomeApp.currentUser.getGmailContacts()

    promise.done (channels) =>
      @$findingLoader.hide()
      @showChannels channels, @$(".welcome-channel-list").hide()

  openJsWindow: ->
    url    = "/auth/google_oauth2"
    width  = 575
    height = 400
    left   = ($(window).width()  - width)  / 2
    top    = ($(window).height() - height) / 2
    opts   = 'status=1' +
      ',width='  + width  +
      ',height=' + height +
      ',top='    + top    +
      ',left='   + left

    @jsWindow = window.open(url, 'twitter', opts)

    false

  showChannels: (channels, el) ->
    @channelsList = new WelcomeApp.Views.SuggestChannelsList
      el: el
      model: channels
      withEmail: true
    el.fadeIn(500)
