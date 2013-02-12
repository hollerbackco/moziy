App.Models.Airing = Backbone.Model.extend
  getNotes: (callback) ->
    get = $.ajax
      url: "/channels/#{@get("channel_id")}/videos/#{@id}/notes",

  comment: (body) ->
    $.ajax
      url: "/airings/#{@id}/comments.json"
      type: "POST"
      data:
        body: body

