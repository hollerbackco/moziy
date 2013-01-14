App.Views.AddModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/add_modal']

  events:
    "click .add-airing" : "showAiringForm"

  initialize: ->
    _.bindAll this, "show", "close", "add"

    @listenTo App.vent, "modals:add", @show
    @listenTo App.vent, "modals:close", @close

    @render()

  render: ->
    @$el.modal().modal("hide")

    @$el.html @template()

    @_setupChannels()
    #@channelsListView = new App.Views.ModalChannelList
      #el: "#addable-channels"
      #model: App.currentUser.channels
      #channelClickCallback: @add

  show: (airing) ->
    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  add: (channel) ->
    console.log channel

  showAiringForm: ->
    @$(".choose-add-type").hide()
    @$(".add-airing-body").show()

  _setupChannels: ->
    $select = @$("select")
    App.currentUser.channels.each (channel) ->
      $select.append "<option value=\"#{channel.id}\">#{channel.get 'title'}</option>"
