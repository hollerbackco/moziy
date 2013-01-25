App.Views.LoginModal = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/login_modal']

  initialize: ->
    _.bindAll this, "show", "close"

    @listenTo App.vent, "modals:close", @close

    @render()

  render: ->
    @$el.modal().modal("hide")

    @$el.html @template()


  show: ->
    @$el.modal("show")

  close: ->
    @$el.modal("hide")
