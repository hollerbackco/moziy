if typeof(window.App) == "undefined" then window.App = {}

$.extend window.App, 
  effects:
    instantiate: ->
      @channelMenu()
    channelMenu: ->
      $("#channel-menu").hoverIntent
      
      