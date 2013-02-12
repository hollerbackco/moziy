App.Views.CommentForm = Backbone.View.extend
  events:
    "click #comment-submit" : "submit"

  initialize: ->
    _.bindAll this, "submit", "onFocus", "onBlur", "resetForm"
    @$button = @$("#comment-submit")

    @$body = @$("#comment-body")
    @$body.focus @onFocus
    @$body.blur @onBlur

  submit: ->
    body = @$body.val()

    if @isValid()
      @loading()

      get = @model.comment(body)

      get.done (msg) =>
        @trigger "success"
        App.vent.trigger "airing:comment", msg
        @resetForm()

      get.fail (msg) =>
        @trigger "fail", msg
        App.vent.trigger "error", msg

  resetForm: ->
    @_clearForm()
    @ready()
    @onBlur()

  loading: ->
    @$button.attr "disabled", "disabled"

  ready: ->
    @$button.removeAttr "disabled"

  onFocus: ->
    @$el.addClass "active"

  onBlur: ->
    if !@isValid()
      @$el.removeClass "active"

  isValid: ->
    body = @$body.val()
    body? and body != ""

  _refreshNotes: ->
    @restreamList.clear()
    @model.getNotes().done (msg) =>
      @restreamList.refresh msg.notes

  _clearForm: ->
     @$("#comment-body").val ""
