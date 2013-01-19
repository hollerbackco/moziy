App.Models.Channel = Backbone.Model.extend

  initialize: ->
    if @has "channel_id"
      @id = @get("channel_id")

  watchAiring: ->
    if @has("unread_count") and @get("unread_count") > 0
      @set(@get("unread_count") - 1)

  getAiringFromID: (airing,callback) ->
    self = this
    $.ajax
      url: "/channels/#{@id}/videos/#{airing.id}",
      success: (results) ->
        airing = new App.Models.Airing(results)

        callback(airing) if callback?

  getFirstAiring: (callback) ->
    $.ajax
      url: "/channels/#{@id}/videos/first",
      success: (results) ->
        airing = new App.Models.Airing(results)
        if callback?
          callback airing

  getNextAiring: (airing, callback) ->
    $.ajax
      url: "/channels/#{@id}/videos/#{airing.id}/next",
      success: (results) ->
        airing = new App.Models.Airing(results)
        callback airing if callback?

