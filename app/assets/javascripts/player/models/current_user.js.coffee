App.Models.CurrentUser = Backbone.Model.extend
  initialize: ->
    if @has("channels")
      @setChannels @get "channels"

  setChannels: (channels_json) ->
    @channels = new App.Models.Channels(channels_json)

  restream: (airing, channel, callback) ->
    $.ajax
      url: "/manage/channels/#{channel.id}/airings?video_id=#{airing.id}"
      type: "POST"
      success: (results) =>
        if results.success
          alert_message = "Rechanneled to #{results.channel_title}"
        else
          alert_message = results.msg

        if callback?
          callback alert_message

  like: (airing, callback) ->
    $.ajax
      url: "/channels/#{airing.get "channel_id"}/likes?airing_id=#{airing.id}"
      type: "POST"
      success: (results) =>
        callback() if callback?
