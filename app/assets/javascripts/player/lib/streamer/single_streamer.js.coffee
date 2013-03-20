#= require player/lib/streamer/base_streamer

class App.SingleStreamer extends App.BaseStreamer
  constructor: (channel) ->
    _.bindAll this, "start", "next", "get",
      "_watchAiring", "_getNextAiring"

    @streamType = "single"
    @channel = channel

  # returns promise with App.Models.Airing
  start: (id) ->
    get = @channel.getAiring(id)

    chained = get.pipe (airing) =>
      channel: @channel
      airing: airing

    chained.done @_watchAiring

    chained

  get: ->
    @current

  # returns App.Models.Airing
  next: ->
    @_watchAiring(@nextup)

  _watchAiring: (obj) ->
    @current = obj

    @_getNextAiring()

    @current

  _getNextAiring: ->
    get = @channel.getNextAiring(@current.airing.id)

    get.done (airing) =>
      @nextup =
        channel: @channel
        airing: airing
