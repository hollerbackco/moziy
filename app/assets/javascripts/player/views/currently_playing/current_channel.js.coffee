App.Views.CurrentChannel = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/current_channel']
  events:
    "click .follow-button.primary" : "follow"
    "click .follow-button.following" : "unfollow"
    "click .edit"   : "edit"

  initialize: ->
    _.bindAll this, "follow", "edit", "show", "render"
    @listenTo App.vent, "channel:watch", @show

  show: (channel) ->
    @stopListening @model
    @model = channel
    @listenTo @model, "change", @render
    @render()

  render: ->
    @$el.html @template @model.toJSON()
    @$following = @$(".follow-button")

    @_updateButton()

  follow: ->
    App.vent.trigger "channel:follow", @model
    @_followClicked()

  unfollow: ->
    App.vent.trigger "channel:follow", @model
    @_unfollowClicked()

  edit: ->

  _updateButton: ->
    if App.currentUser.isFollowing @model
      @_followClicked()
    else
      @_unfollowClicked()

  _followClicked: ->
    @$following.removeClass "primary"
    @$following.addClass "following"

  _unfollowClicked: ->
    @$following.addClass "primary"
    @$following.removeClass "following"

