$ ->
  
  if typeof(window.App) == "undefined" then window.App = {}

  $.extend window.App, 
    effects:
      instantiate: ->
        @channelMenu()
        @mainMenu()
        
      mainMenu: ->
        $("#main-menu").hoverIntent
          over: ->
            $(".channels").show().addClass("hover")
          sensitivity: 9
          timeout: 500
          out: ->
            $(".channels").hide().removeClass("hover")
            
      channelMenu: ->
        $("#channel-menu").hoverIntent
          over: ->
            $("#info .title").show().addClass("hover")
          timeout: 500
          out: ->
            $("#info .title").hide().removeClass("hover")
  window.App.effects.instantiate()
