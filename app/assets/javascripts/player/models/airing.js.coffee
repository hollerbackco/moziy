App.Models.Airing = Backbone.Model.extend
  getNotes: (callback) ->
    get = $.ajax
      url: "/channels/#{@get("channel_id")}/videos/#{@id}/notes",
