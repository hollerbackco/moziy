App.Models.Channel = Backbone.Model.extend
  initialize: ->
    _.bindAll this, "getAiring", "_getFirstAiring",
      "getNextAiring", "_getAiring"

    if @has "channel_id"
      @id = @get("channel_id")

  getAiring: (id) ->
    if id?
      @_getAiring id
    else
      @_getFirstAiring()

  # returns a promise
  getNextAiring: (id) ->
    promise = $.ajax({url: "/channels/#{@id}/videos/#{id}/next"})
      .pipe (results) ->
        airing = new App.Models.Airing results
    promise

  # returns a promise
  _getFirstAiring: ->
    promise = $.ajax({url: "/channels/#{@id}/videos/first"})
      .pipe (results) ->
        airing = new App.Models.Airing results
    promise

  # returns a promise
  _getAiring: (airing_id) ->
    promise = $.ajax({url: "/channels/#{@id}/videos/#{airing_id}"})
      .pipe (results) ->
        airing = new App.Models.Airing results
    promise


