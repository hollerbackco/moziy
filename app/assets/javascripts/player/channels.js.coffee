$ ->

  $.extend window.App,
    channels:
      change: (channel_id, list_item) ->
        $(".channel").removeClass("previewing")
        $(list_item).addClass("previewing")
        url = "/channels/#{channel_id}/chromeless"
        $("#viewer-iframe").attr("src", url)
        
      _notice: (msg) ->
        alert(msg)
        
      _reairVideo: (channel_id) ->
        video_id = window.App.playerManager.getCurrentVideoID()
        from_id = window.App.playerManager.getCurrentChannelID()
        $.ajax
          url: "/manage/channels/#{channel_id}/airings?video_id=#{video_id}&from_id=#{from_id}",
          type: "POST"
          success: (msg) =>
            if msg.success
              alert_message = "Rechanneled to #{msg.channel_title}"
            else
              @_notice(msg.msg)
            
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
      changeBindings: ->
        $(".channel").click (e) ->
          channel_id = $(this).attr("data-channel-id")
          window.App.channels.change channel_id, this
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
