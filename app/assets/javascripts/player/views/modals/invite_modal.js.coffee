App.Views.InviteModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/invite_modal']

  events:
    "submit form": "invite"

  initialize: ->
    _.bindAll this, "show", "close", "invite", "_showErrors", "_success", "_validateForm"

    @listenTo App.vent, "modals:close", @close
    @render()

  render: ->
    @$el.modal().modal("hide")

    @$el.html @template()
    @$errors = @$("#request-invite-errors")
    @$el.on "hidden", @onClose

  show: ->
    App.vent.trigger "player:pause"
    App.vent.trigger "modals:close"
    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  onClose: ->
    App.vent.trigger "player:pause"

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
