App.Views.AddModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/add_modal']

  events:
    "click .add-airing" : "showAiringForm"
    "click #add-airing" : "add"

  initialize: ->
    _.bindAll this, "show", "close", "add"

    @listenTo App.vent, "modals:close", @close

    @render()

  render: ->
    @$el.modal().modal("hide")
    @$el.html @template()
    @_setupChannels()
    @$button = @$(".button.primary")

  show: (airing) ->
    @render()
    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  add: ->
    urls = @$("#video-urls").val()
    id = @$("#channel-id").val()

    if urls? and urls != "" and id?
      @loading()
      video = new App.Models.Video()
      get = video.create("/me/channels/#{id}/videos", urls)

      get.done (msg) =>
        App.vent.trigger "airing:add", msg
        @_clearForm()
        @close()

      get.fail (msg) =>
        @close()
        App.vent.trigger "error", msg

    else
      @$(".modal-body").prepend $("<div>").html("Please add a url").delay(200).remove()

  loading: ->
    @$button.attr "disabled", "disabled"

  _clearForm: ->
     @$("#video-urls").val ""

  showAiringForm: ->
    @$(".choose-add-type").hide()
    @$(".add-airing-body").show()

  _setupChannels: ->
    $select = @$("select")
    App.currentUser.channels.each (channel) ->
      $select.append "<option value=\"#{channel.id}\">#{channel.get 'title'}</option>"
