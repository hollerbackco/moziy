App.Models.CurrentUser = Backbone.Model.extend
  initialize: ->
    if @has("channels")
      @setChannels @get "channels"
    else
      @setChannels []

    if @has("channel_list")
      @setChannelList @get "channel_list"
    else
      @setChannelList []

  loggedIn: ->
    @get("loggedIn") || false

  isFollowing: (channel) ->
    @channelList? and @channelList.hasChannel channel

  setChannels: (channels) ->
    @channels = new App.Models.Channels(channels)
    @channels.url = "/me/channels.json"

  setChannelList: (channels) ->
    @channelList = new App.Models.Channels(channels)
    @channelList.url = "/me/channels/following.json"

  follow: (channel) ->
    get = $.ajax
      url: "/channels/#{channel.id}/subscribe"
      type: "POST"

    get.done (results) =>
      if results.subscribed
        @channelList.add channel
      else
        @channelList.remove channel

  restream: (airing, channel, callback) ->
    $.ajax
      url: "/me/channels/#{channel.id}/airings?video_id=#{airing.id}"
      type: "POST"
      success: (results) =>
        if results.success
          alert_message = "restreamed to /#{results.channel_slug}"
        else
          alert_message = results.msg

        if callback?
          callback alert_message

  like: (airing, callback) ->
    $.ajax
      url: "/channels/#{airing.get "channel_id"}/likes?airing_id=#{airing.id}"
      type: "POST"
      success: (results) =>
        if callback?
          callback results
