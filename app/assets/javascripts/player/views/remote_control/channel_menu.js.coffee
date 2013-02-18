App.Views.RemoteControlChannelMenu = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/remote_control_pane/remote_control_channel_menu']
  events:
    "click .home" : "showHome"
    "click .explore" : "showExplore"
    "click .me" : "showMe"

  initialize: ->
    @homeChannels = App.currentUser.channelList || App.exploreChannels || (new App.Models.Channels())
    @exploreChannels = App.exploreChannels
    @myChannels = App.currentUser.channels

    @render()

    if @homeChannels.length > 1
      @showHome()
    else
      @$(".explore").click()
      @showExplore()

  render: ->
    @$el.html @template()

    @exploreListView = new App.Views.RemoteControlExploreList
      model: @exploreChannels

    @channelListView = new App.Views.RemoteControlChannelList
      model: @homeChannels

    @$container = @$("#channels-container")

  sort: ->
    @exploreListView.sort()

  showHome: ->
    @$container.html @channelListView.show(@homeChannels).$el

  showExplore: ->
    @$container.html @exploreListView.render().$el

  showMe: ->
    @$container.html @channelListView.show(@myChannels).$el

