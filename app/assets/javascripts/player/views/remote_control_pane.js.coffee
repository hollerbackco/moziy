App.Views.RemoteControlPane = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/remote_control_pane']
  events:
    "click .menu-button" : "activateMenuItem"
    "click .add"  : "showAdd"
    "click .home" : "showHome"
    "click .explore" : "showExplore"
    "click .me" : "showMe"

  initialize: ->
    @homeChannels = App.currentUser.channelList
    @exploreChannels = App.exploreChannels
    @myChannels = App.currentUser.channels

    @render()
    @showHome()

  render: ->
    @$el.html @template()
    @channelListView = new App.Views.RemoteControlChannelList
      model: @homeChannels
      el: @$(".channels")

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

