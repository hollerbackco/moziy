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

  show: (airing) ->
    @render()
    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  add: ->
    urls = @$("#video-urls").val()
    id = @$("#channel-id").val()

    if urls? and urls != "" and id?
      get = $.ajax
        url: "/me/channels/#{id}/videos.json"
        type: "POST"
        data:
          links: urls

      get.done (results) =>
        App.vent.trigger "airing:add", results.airings
        @_clearForm()
        @close()
    else
      @$(".modal-body").prepend $("<div>").html("Please add a url").delay(200).remove()

  _clearForm: ->
     @$("#video-urls").val ""

  showAiringForm: ->
    @$(".choose-add-type").hide()
    @$(".add-airing-body").show()

  _setupChannels: ->
    $select = @$("select")
    App.currentUser.channels.each (channel) ->
      $select.append "<option value=\"#{channel.id}\">#{channel.get 'title'}</option>"
