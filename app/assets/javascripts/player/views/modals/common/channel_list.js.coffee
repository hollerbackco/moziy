App.Views.ModalChannelList = Backbone.View.extend

  initialize: ->
    @channelClickCallback = @options.channelClickCallback

    if @options.channelTemplate?
      @channelTemplate = @options.channelTemplate

    @render()

  render: ->
    @model.each (channel) =>
      subview = new App.Views.ModalChannelItem
        model: channel
        channelTemplate: @channelTemplate

      @$el.append subview.el
      @listenTo subview, "click", @channelClickCallback
