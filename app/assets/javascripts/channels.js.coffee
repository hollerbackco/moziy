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
            $(this).addClass("hover")
            $(".channels").show()
          sensitivity: 11
          timeout: 100
          out: ->
            $(this).removeClass("hover")
            $(".channels").hide()
            
      channelMenu: ->
        $("#channel-menu").hoverIntent
          over: ->
            $("#info .title").show().addClass("hover")
          timeout: 500
          out: ->
            $("#info .title").hide().removeClass("hover")
  window.App.effects.instantiate()
