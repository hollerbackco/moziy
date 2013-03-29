WelcomeApp.Views.SuggestChannelItem = Backbone.View.extend
  tagName: "li"
  className: "clearfix"
  template: HandlebarsTemplates['welcome/templates/suggest_channel_item']

  events:
    "click .follow-button:not(.following)": "follow"
    "click .follow-button.following": "unfollow"

  initialize: ->
    _.bindAll this, "follow", "unfollow"
    @render()

  render: ->
    @$el.html @template @model.toJSON()

    @$following = @$(".follow-button")

    if WelcomeApp.currentUser? and WelcomeApp.currentUser.isFollowing(@model)
      @_followClicked()

  follow: ->
    WelcomeApp.vent.trigger "channel:follow", @model
    @_followClicked()

  unfollow: ->
    WelcomeApp.vent.trigger "channel:unfollow", @model
    @_unfollowClicked()

  _followClicked: ->
    @$following.addClass "following"
    @$el.addClass "following"

  _unfollowClicked: ->
    @$following.removeClass "following"
    @$el.removeClass "following"

