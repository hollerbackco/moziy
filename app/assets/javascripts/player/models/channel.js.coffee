App.Models.Channel = Backbone.Model.extend
  initialize: ->
    _.bindAll this, "watchNext", "_getFirstAiring",
      "_getNextAiring", "_watchAiring", "_setNextUp", "_getAiring"

    if @has "channel_id"
      @id = @get("channel_id")
      @urlPrefix = "/channels/#{@id}/videos"

  startWatching: (airing_id) ->
    promise = if airing_id? then @_getAiring(airing_id) else @_getFirstAiring()
    promise.done @_watchAiring
    promise

  watchNext: ->
    @_watchAiring @nextup

  _watchAiring: (airing) ->
    @watching = airing

    @_setUnreadCount()

    #get the next one
    promise = @_getNextAiring()
    promise.done @_setNextUp

    @watching

  _getFirstAiring: ->
    get = $.ajax({url: "#{@urlPrefix}/first"})
      .pipe (results) ->
        airing = new App.Models.Airing results
    get

  _getAiring: (airing_id) ->
    get = $.ajax({url: "#{@urlPrefix}/#{airing_id}"})
      .pipe (results) ->
        airing = new App.Models.Airing results
    get

  # returns a promise
  _getNextAiring: ->
    get = $.ajax({url: "#{@urlPrefix}/#{@watching.id}/next"})
      .pipe (results) ->
        airing = new App.Models.Airing results
    get

  _setNextUp: (airing) ->
    @nextup = airing

  _setUnreadCount: ->
    if @has("unread_count") and (@get("unread_count") > 0)
      @set("unread_count", (@get("unread_count") - 1))
