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
    @commentForm = new App.Views.CommentForm
      el: $("#comment-form")

    @commentForm.on "success", @_refreshNotes

  show: (airing) ->
    @model = airing
    @commentForm.model = @model

    @$(".airing-title").html @model.get("title")
    @_refreshNotes()
    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  _refreshNotes: ->
    @restreamList.clear()
    @model.getNotes().done (msg) =>
      @restreamList.refresh msg.notes
