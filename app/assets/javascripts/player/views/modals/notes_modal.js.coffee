App.Views.NotesModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/notes_modal']

  initialize: ->
    _.bindAll this, "show", "close"

    @listenTo App.vent, "airing:notes", @show
    @listenTo App.vent, "modals:close", @close

    @render()

  render: ->
    @$el.modal().modal("hide")
    @$el.html @template()
    @restreamList = new App.Views.RestreamList(el: $("#notes-restreams"))

  show: (airing) ->
    @$(".airing-title").html airing.get("title")

    airing.getNotes (notes) =>
      @restreamList.refresh(notes.restreams)

    @$el.modal("show")

  close: ->
    @$el.modal("hide")
