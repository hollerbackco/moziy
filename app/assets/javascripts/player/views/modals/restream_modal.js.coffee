App.Views.RestreamModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/restream_modal']

  initialize: ->
    _.bindAll this, "restream"
    @listenTo App.vent, "modals:restream", @show
    @listenTo App.vent, "modals:close", @close

    @render()

  render: ->
    @$el.modal().modal("hide")
    @$el.html @template()

    @channelsListView = new App.Views.ModalChannelList
      el: "#restreamable-channels"
      model: App.currentUser.channels
      channelClickCallback: @restream


  show: (@model) ->
    App.vent.trigger "modals:close"

    @$(".airing-title").html @model.get("title")
    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  restream: (channel) ->
    App.vent.trigger "airing:restream", @model, channel
    App.vent.trigger "modals:close"

