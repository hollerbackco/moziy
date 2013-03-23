App.Views.ChannelModal = Backbone.View.extend

  events:
    "click .follow-button.primary" : "follow"
    "click .follow-button.following" : "unfollow"
    "click .play-channel":   "watch"
    "click .show-followers": "followers"

  template: HandlebarsTemplates['player/templates/channel_modal']

  initialize: ->
    _.bindAll this, "show", "close", "follow", "unfollow"

    @$el.modal().modal("hide")

    @listenTo App.vent, "modals:channel", @show
    @listenTo App.vent, "modals:close", @close

  show: (channel) ->
    App.vent.trigger "modals:close"

    @channel = channel

    @$el.html @template @channel.toJSON()
    @$el.modal("show")

    @$following = @$(".follow-button")

    @_updateButton()

  close: ->
    @$el.modal("hide")

  #follow
  follow: ->
    App.vent.trigger "channel:follow", @channel
    @_followClicked()

  unfollow: ->
    App.vent.trigger "channel:follow", @channel
    @_unfollowClicked()

  watch: ->
    App.vent.trigger "channel:watch", @channel
    App.vent.trigger "modals:close"

  followers: ->
    App.vent.trigger "channel:followers", @channel

  _updateButton: ->
    if App.currentUser.isFollowing @channel
      @_followClicked()
    else

  _followClicked: ->
    @$following.removeClass "primary"
    @$following.addClass "following"

  _unfollowClicked: ->
    @$following.addClass "primary"
    @$following.removeClass "following"

