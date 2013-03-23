App.Views.SharingModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/sharing_modal']

  initialize: ->
    _.bindAll this, "show", "close"

    @listenTo App.vent, "modals:close", @close

    @$el.modal().modal("hide")

  render: ->
    @$el.html @template
      url: decodeURIComponent(@model.get "url")
      title: @model.get "title"

  show: (model) ->
    @model = model
    App.vent.trigger "modals:close"
    @render()
    @$el.modal("show")

  close: ->
    @$el.modal("hide")
