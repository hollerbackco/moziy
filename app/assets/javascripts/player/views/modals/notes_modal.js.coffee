App.Views.NotesModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/notes_modal']

  initialize: ->
    _.bindAll this, "show", "close", "_refreshNotes"

    @listenTo App.vent, "airing:notes", @show
    @listenTo App.vent, "modals:close", @close

    @render()

  render: ->
    @$el.modal().modal("hide")
    @$el.html @template()
    @restreamList = new App.Views.RestreamList(el: $("#notes-restreams"))
    @likeList = new App.Views.LikeList(el: $("#notes-likes"))

  show: (airing) ->
    @model = airing

    @$(".airing-title").html @model.get("title")
    @_refreshNotes()
    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  _refreshNotes: ->
    @restreamList.clear()
    @model.getNotes().done (notes) =>
      @likeList.refresh notes.likes
      @restreamList.refresh notes.restreams
