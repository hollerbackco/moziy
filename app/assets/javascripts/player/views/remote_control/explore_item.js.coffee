App.Views.RemoteControlExploreListItem = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/remote_control_pane/explore_item']
  tagName: "li"
  className: "explore-channel clearfix"

  events:
    "click .header": "watch"
    "click .follow-button": "follow"
    "click .follow-button.following": "unfollow"

  initialize: ->
    _.bindAll this, "updateCount", "follow", "unfollow", "watch"
    @model.on "change:unread_count", @updateCount
    @render()

  render: ->
    @$el.html @template @model.toJSON()

    @$following = @$(".follow-button")

    if App.currentUser? and App.currentUser.isFollowing(@model)
      @_followClicked()

  watch: ->
    App.vent.trigger "channel:watch", @model

  follow: ->
    App.vent.trigger "channel:follow", @model
    @_followClicked()

  unfollow: ->
    App.vent.trigger "channel:follow", @model
    @_unfollowClicked()

  remove: ->
    @$el.remove()

  updateCount: ->
    @$(".unread-count").html @model.get("unread_count")

  _followClicked: ->
    @$following.removeClass "primary"
    @$following.addClass "following"
    @$el.addClass "following"

  _unfollowClicked: ->
    @$following.addClass "primary"
    @$following.removeClass "following"
    @$el.removeClass "following"

