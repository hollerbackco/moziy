App.Views.MultiimageModal = App.Views.ImageModal.extend
  template: HandlebarsTemplates['player/templates/multiimage_modal']
  events:
    "click img":       "next"
    "click .next-tip": "next"

  initialize: ->
    _.bindAll this, "show", "close", "next"

    @$el.modal().modal("hide")

    @images = @options.images
    @currentImage = @images.shift()
    @title = @options.title

    @listenTo App.vent, "modals:multiimage", @show
    @listenTo App.vent, "modals:close", @close
    @$el.on "hidden", @onClose

    @render()

  render: ->
    @$el.html @template
      title: @title
      image_url: @currentImage

    @multi = @$(".multi-image")

  show: ->
    App.vent.trigger "player:pause"
    @multi.attr "src", @currentImage
    @$el.modal("show")

  onClose: ->
    console.log "hello"
    App.vent.trigger "player:pause"

  next: ->
    @images.push @currentImage
    @currentImage = @images.shift()
    @multi.attr "src", @currentImage
