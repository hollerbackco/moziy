$ ->
  
  if typeof(window.App) == "undefined" then window.App = {}

  $.extend window.App,
    channels:
      _reairVideo: (channel_id) ->
        $.ajax
          url: "/manage/channels/#{channel_id}/airings?video_id=#{window.App.playerManager.getCurrentVideoID()}",
          type: "POST"
          success: (msg) ->
            console.log msg
            
    effects:
      instantiate: ->
        @channelMenu()
        @mainMenu()
        @reairBindings()
        
      mainMenu: ->
        $("#main-menu").hoverIntent
          over: ->
            $(this).addClass("hover")
            $(".channels").show()
          sensitivity: 12
          timeout: 100
          out: ->
            $(this).removeClass("hover")
            $(".channels").hide()
      
      channelMenu: ->
        $("#actions").hoverIntent
          over: ->
            $(".buttons", this).show().addClass("hover")
            $(".mark", this).hide()
          sensitivity: 13
          timeout: 100
          out: ->
            $(".buttons", this).hide().removeClass("hover")
            $(".mark", this).show()
      reairBindings: ->
        $(".reair").click (e) ->
          channel_id = $(this).attr("data-channel-id")
          window.App.channels._reairVideo channel_id
          e.preventDefault()
  window.App.effects.instantiate()
