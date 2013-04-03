App.Views.MultiimageModal = App.Views.ImageModal.extend
  events:
    "click img": "next"

  initialize: ->
    _.bindAll this, "show", "close"

    @$el.modal().modal("hide")

    @images = @options.images

    @listenTo App.vent, "modals:multiimage", @show
    @listenTo App.vent, "modals:close", @close

  next: ->
    image = @images.shift()
