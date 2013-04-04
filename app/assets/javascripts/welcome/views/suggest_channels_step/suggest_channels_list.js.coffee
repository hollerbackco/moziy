WelcomeApp.Views.SuggestChannelsList = Backbone.View.extend
  initialize: ->
    _.bindAll this, "renderOne"
    @withEmail = @options.withEmail
    @render()

  render: ->
    if @model?
      @model.each @renderOne

  append: (channels, title=null) ->
    if title?
      @$el.append $("<li />").addClass("title category").html(title)

    channels.each @renderOne

  renderOne: (channel) ->
    subview = new WelcomeApp.Views.SuggestChannelItem
      model: channel
      withEmail: @withEmail

    @listenTo subview, "channel:follow", (model) =>
      @trigger "channel:follow", model

    @listenTo subview, "channel:unfollow", (model) =>
      @trigger "channel:unfollow", model

    @$el.append subview.el
