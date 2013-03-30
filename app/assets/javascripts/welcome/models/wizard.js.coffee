WelcomeApp.Models.Wizard = Backbone.Model.extend
  initialize: ->
    @steps = []
    @currentStep = 0

  current: ->
    @steps[@currentStep]

  next: ->
    ++@currentStep
    @currentStep = @modIndex @currentStep

    if @currentStep == 0
      @trigger "done"

    @current()

  back: ->
    --@currentStep
    @currentStep = @modIndex @currentStep

    @current()

  register: (step) ->
    @steps.push step

  modIndex: (i) ->
    i % @length()

  length: ->
    @steps.length
