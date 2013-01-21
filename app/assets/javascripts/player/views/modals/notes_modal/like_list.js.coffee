App.Views.LikeList = Backbone.View.extend
  initialize: ->

  # should be a collection
  refresh: (likes) ->
    @$("#notes-likes-count").html "#{likes.length} Likes"
    @$("#notes-likes-list").html likes.join ", "
