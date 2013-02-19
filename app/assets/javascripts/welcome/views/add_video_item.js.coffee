WelcomeApp.Views.AddVideoItem = Backbone.View.extend
  tagName: "li"
  className: "video video-card clearfix"
  template: HandlebarsTemplates['welcome/templates/add_video_item']

  initialize: ->
    @$el.hide()
    @render()

  render: ->
    @$el.html @template @model.toJSON()
