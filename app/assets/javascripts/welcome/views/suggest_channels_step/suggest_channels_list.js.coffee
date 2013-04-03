WelcomeApp.Views.SuggestChannelsList = Backbone.View.extend
  initialize: ->
    @withEmail = @options.withEmail
    @render()

  render: ->
    @model.each (channel) =>
      subview = new WelcomeApp.Views.SuggestChannelItem
        model: channel
        withEmail: @withEmail

      @listenTo subview, "channel:follow", (model) =>
        @trigger "channel:follow", model

      @listenTo subview, "channel:unfollow", (model) =>
        @trigger "channel:unfollow", model

      @$el.append subview.el
