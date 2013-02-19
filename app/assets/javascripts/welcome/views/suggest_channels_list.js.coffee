WelcomeApp.Views.SuggestChannelsList = Backbone.View.extend
  initialize: ->
    @render()

  render: ->
    @model.each (channel) =>
      subview = new WelcomeApp.Views.SuggestChannelItem
        model: channel

      @$el.append subview.el
