if typeof(window.App) == "undefined" then window.App = {}

$ ->

  $.extend window.App,
    channels:
      _notice: (msg) ->
        alert(msg)
      _subscribe: (channel_id, dom_item) ->
        dom_item.addClass("load")
        $.ajax
          url: "/channels/#{channel_id}/subscribe",
          type: "POST"
          success: (msg) =>
            dom_item.removeClass("load")
            dom_item.toggleClass("favorited")
      preview: (channel_id, list_item) ->
        $(".channel").removeClass("previewing")
        $(list_item).addClass("previewing")
        url = "/channels/#{channel_id}/chromeless"
        $("#viewer-iframe").attr("src", url)
        
            
    instantiate: ->

      @previewHover()
      @subscribeBindings()
      $(".channel").first().click()
      
    previewHover: ->
      $(".channel").click ->
        channel_id = $(this).attr("data-channel-id")
        console.log channel_id
        window.App.channels.preview channel_id, this
      
    subscribeBindings: ->
      $(".star").click (e) ->
        li = $(this).parents(".channel")
        unless li.hasClass("load")
          channel_id = li.attr("data-channel-id")
          window.App.channels._subscribe channel_id, li

        e.preventDefault()
  window.App.instantiate()
