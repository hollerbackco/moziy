WelcomeApp.Views.SuggestChannelItem = Backbone.View.extend
  tagName: "li"
  className: "clearfix"
  template: HandlebarsTemplates['welcome/templates/suggest_channel_item']

  events:
    "click .follow-button:not(.following)": "follow"
    "click .follow-button.following": "unfollow"

  initialize: ->
    _.bindAll this, "follow", "unfollow"
    @withEmail = @options.withEmail
    @render()

  render: ->
    @$el.html @template @model.toJSON()

    @$following = @$(".follow-button")

    if @withEmail
      span = $("<div />").addClass("email").html @model.get("email")
      @$el.prepend span

    if WelcomeApp.currentUser? and WelcomeApp.currentUser.isFollowing(@model)
      @_followClicked()

  follow: ->
    WelcomeApp.vent.trigger "channel:follow", @model
    @_followClicked()

  unfollow: ->
    WelcomeApp.vent.trigger "channel:unfollow", @model
    @_unfollowClicked()

  _followClicked: ->
    @$following.removeClass "primary"
    @$following.addClass "following"
    @$el.addClass "following"

  _unfollowClicked: ->
    @$following.addClass "primary"
    @$following.removeClass "following"
    @$el.removeClass "following"
