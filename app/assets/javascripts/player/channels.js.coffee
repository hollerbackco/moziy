$ ->

  $.extend window.App,
    channels:
      _notice: (msg) ->
        alert(msg)

      _likeVideo: ->
        video_id = window.App.playerManager.getCurrentVideoID()
        from_id = window.App.playerManager.getCurrentChannelID()
        $.ajax
          url: "/channels/#{from_id}/likes?video_id=#{video_id}",
          type: "POST"
          success: (msg) =>
            alert_message = "Liked to #{msg.video_title}"
            alert alert_message

      _reairVideo: (channel_id) ->
        video_id = window.App.playerManager.getCurrentVideoID()
        from_id = window.App.playerManager.getCurrentChannelID()
        $.ajax
          url: "/manage/channels/#{channel_id}/airings?video_id=#{video_id}&from_id=#{from_id}",
          type: "POST"
          success: (msg) =>
            if msg.success
              alert_message = "Rechanneled to #{msg.channel_title}"
              alert alert_message
            else
              @_notice(msg.msg)

    effects:
      instantiate: ->
        @channelMenu()
        @mainMenu()
        @reairBindings()
        @muteButton()

      muteButton: ->
        $("#mute").click ->
          $(this).toggleClass("on")
          window.App.playerManager.toggleMute()

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
        $(".like").click (e) ->
          window.App.channels._likeVideo()
          e.preventDefault()

  window.App.effects.instantiate()
