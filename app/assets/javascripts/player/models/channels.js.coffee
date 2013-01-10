#= require player/models/channel

App.Models.Channels = Backbone.Collection.extend
  model: App.Models.Channel

  hasChannel: (channel) ->
    @get(channel.id)?
