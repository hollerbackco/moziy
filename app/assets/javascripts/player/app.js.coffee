window.App =
  Views: {}
  Models: {}

#$ ->
  #( (App,Backbone) ->

    #App.vent = _.extend {}, Backbone.Event

    #App.playerManager = new App.PlayerManager()

    #App.remoteControlPane = new App.Views.RemoteControlPane(el: "#remote-control-pane")

    ##App.currentlyPlayingPane = new App.Views.CurrentlyPlayingPane()

    ##App.modal = new App.Views.Modal()


  #)(window.App, Backbone)

