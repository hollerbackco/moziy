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
    @showHome()

  render: ->
    @$el.html @template()
    @channelListView = new App.Views.RemoteControlChannelList
      model: @homeChannels
      el: @$(".channels")

  showHome: ->
    @channelListView.show @homeChannels

  showExplore: ->
    @channelListView.show @exploreChannels

  showMe: ->
    @channelListView.show @myChannels

