WelcomeApp.Views.SuggestChannelsList = Backbone.View.extend
  initialize: ->
    @withEmail = @options.withEmail
    @render()

  render: ->
    @model.each (channel) =>
      subview = new WelcomeApp.Views.SuggestChannelItem
        model: channel
        withEmail: @withEmail

      @$el.append subview.el
