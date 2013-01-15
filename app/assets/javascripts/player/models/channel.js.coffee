App.Models.Channel = Backbone.Model.extend

  initialize: ->
    if @has "channel_id"
      @id = @get("channel_id")

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

