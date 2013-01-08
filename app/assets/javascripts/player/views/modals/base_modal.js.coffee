class App.Views.BaseModal extends Backbone.View

  initialize: ->
    @$el.modal()

  show: ->
    @$el.modal("show")
