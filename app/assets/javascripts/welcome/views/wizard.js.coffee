WelcomeApp.Views.Wizard = Backbone.View.extend
  initialize: ->
    @model = new WelcomeApp.Models.Wizard()

    @listenTo WelcomeApp.vent, "wizard:back", @back
    @listenTo WelcomeApp.vent, "wizard:next", @next

  start: ->
    @$el.html @model.current().render()

  next: ->
    if @model.isComplete()
      @complete()
    else
      @$el.html @model.next().render()

  back: ->
    @$el.html @model.back().render()

  registerStep: (step) ->
    @model.register step

  complete: ->
    WelcomeApp.vent.trigger "wizard:done"
