App.Models.Airing = Backbone.Model.extend

  getNotes: (callback) ->
    $.ajax
      url: "/channels/#{@get("channel_id")}/videos/#{@id}/notes",
      success: (results) ->
        callback(results) if callback?
