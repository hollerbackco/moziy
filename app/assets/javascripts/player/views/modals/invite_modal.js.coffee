App.Views.InviteModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/invite_modal']

  initialize: ->
    _.bindAll this, "show", "close", "invite", "_showErrors", "_success", "_validateForm"

    @listenTo App.vent, "modals:close", @close
    @render()

  render: ->
    @$el.modal().modal("hide")

    @$el.html @template()
    @$errors = @$("#request-invite-errors")

  show: ->
    App.vent.trigger "modals:close"
    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  invite:(e) ->
    e.preventDefault()

    @_validateForm (value) =>
      App.vent.trigger "invite:request", value,
        error: @_showErrors
        success: @_success

  _success: ->
    @$("form").addClass "submitted"
    App.analytics.vent.trigger "invite:request"

  _showErrors: (errors) ->
    @$("form").addClass "has-errors"

    @$errors.empty()

    if errors?
      _.each errors, (error) =>
        div = $("<div />").addClass("error").html(error)
        @$errors.append div


  _validateForm: (callback) ->
    value = @$("input[name=email]").val()

    if value?
      callback(value)
    else
      @showErrors()
