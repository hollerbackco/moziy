App.Views.RestreamModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/restream_modal']

  initialize: ->
    @listenTo App.vent, "modals:restream", @show
    @listenTo App.vent, "modals:close", @close

    @render()

  render: ->
    @$el.modal().modal("hide")
    @$el.html @template()
    @$channelsListView = $("#restreamable-channels")

    App.currentUser.channels.each (channel) =>
      subview = new App.Views.RestreamModalChannelItem(model: channel)
      @$channelsListView.append subview.el
      @listenTo subview, "restream", @restream


  show: (airing) ->
    App.vent.trigger "modals:close"

    @model = airing

    @$(".airing-title").html airing.get("title")
    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  restream: (channel) ->
    App.vent.trigger "airing:restream", @model, channel
    App.vent.trigger "modals:close"

