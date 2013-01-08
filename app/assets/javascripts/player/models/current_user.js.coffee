App.Models.CurrentUser = Backbone.Model.extend
  initialize: ->
    if @has("channels")
      @setChannels @get "channels"
    if @has("channel_list")
      @setChannelList @get "channel_list"

  setChannels: (channels) ->
    @channels = new App.Models.Channels(channels)

  setChannelList: (channels) ->
    @channelList = new App.Models.Channels(channels)

  setSubscriptions: (channels_json) ->
    @subscriptions = new App.Models.Channels(channels_json)

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
