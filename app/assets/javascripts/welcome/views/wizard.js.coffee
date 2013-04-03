WelcomeApp.Views.Wizard = Backbone.View.extend
  initialize: ->
    @model = new WelcomeApp.Models.Wizard()

    @listenTo @model, "done", @complete
    @listenTo WelcomeApp.vent, "wizard:back", @back
    @listenTo WelcomeApp.vent, "wizard:next", @next

  start: ->
    @$el.html @model.current().render()

  next: ->
    @$el.html @model.next().render()

  back: ->
    @$el.html @model.back().render()

  registerStep: (step) ->
    @model.register step

  complete: (step) ->
    WelcomeApp.vent.trigger "wizard:done"
