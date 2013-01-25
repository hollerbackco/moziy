App.Views.InvitePane = Backbone.View.extend
  template: HandlebarsTemplates['player/templates/invite_pane']

  attributes:
    class: "clearfix"
    id: "invite-pane"

  events:
    "click .login":  "login"
    "click .invite": "invite"

  initialize: ->
    @render()

  render: ->
    @$el.html @template()

  login: ->
    App.vent.trigger "modals:login"

  invite: ->
    App.vent.trigger "modals:invite"


