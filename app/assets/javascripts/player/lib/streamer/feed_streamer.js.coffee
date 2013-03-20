#= require player/lib/streamer/base_streamer

class App.FeedStreamer extends App.BaseStreamer
  constructor: ->
    @urlPrefix = "/me/feed"
    _.bindAll this, "start", "next", "_watch", "_getFirst", "_getNextAiring", "_get"

  # returns promise with {channel: .., airing: ..}
  start: ->
    @_get().done @_watch

  # returns App.Models.Airing
  next: ->
    @_watch @nextup

  get: ->
    @current

  # returns promise with App.Models.Airing
  _get: ->
    @_getFirst()

  _watch: (obj) ->
    @current = obj

    @_getNextAiring()

    @current

  _getFirst: ->
    get = $.ajax({url: "#{@urlPrefix}/first"})
      .pipe @_parseJSONfromAPI

    get

  # set nextup
  # returns a promise piped to {channel: .., airing: ..}
  _getNextAiring: ->
    self = this
    get = $.ajax({url: "#{self.urlPrefix}/#{self.current.airing.id}/next"})
      .pipe @_parseJSONfromAPI

    get.done (obj) =>
      console.log obj
      @nextup = obj

    get

  _parseJSONfromAPI: (results) ->
    airing: new App.Models.Airing results
    channel: new App.Models.Channel results.channel
