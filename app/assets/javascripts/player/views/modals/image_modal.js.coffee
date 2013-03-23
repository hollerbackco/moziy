App.Views.ImageModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/image_modal']

  initialize: ->
    _.bindAll this, "show", "close"

    @$el.modal().modal("hide")

    @listenTo App.vent, "modals:keyboard", @show
    @listenTo App.vent, "modals:close", @close

  show: (title, image_url) ->
    App.vent.trigger "modals:close"

    @$el.html @template
      title: title
      image_url: image_url

    @$el.modal("show")


  close: ->
    @$el.modal("hide")
