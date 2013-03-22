App.Views.ChannelListModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/channel_list_modal']

  initialize: ->
    _.bindAll this, "watch", "show"
    @listenTo App.vent, "modals:close", @close

    @render()

  render: ->
    @$el.modal().modal("hide")
    @$el.html @template()

    @channelsListView = new App.Views.ModalChannelList
      el: "#watchable-channels"
      model: App.currentUser.channelList
      channelClickCallback: @watch

  show: ->
    App.vent.trigger "modals:close"

    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  watch: (channel) ->
    App.vent.trigger "channel:watch", channel
    App.vent.trigger "modals:close"

