App.Views.InviteModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/invite_modal']

  initialize: ->
    _.bindAll this, "show", "close"

    @listenTo App.vent, "modals:close", @close
    @render()

  render: ->
    @$el.modal().modal("hide")

    @$el.html @template()

  show: ->
    App.vent.trigger "modals:close"
    @$el.modal("show")

  close: ->
    @$el.modal("hide")
