App.Views.ChannelModal = Backbone.View.extend

  events:
    "click .follow-channel": "follow"
    "click .play-channel":   "watch"
    "click .show-followers": "followers"

  template: HandlebarsTemplates['player/templates/channel_modal']

  initialize: ->
    _.bindAll this, "show", "close"

    @$el.modal().modal("hide")

    @listenTo App.vent, "modals:channel", @show
    @listenTo App.vent, "modals:close", @close

  show: (channel) ->
    App.vent.trigger "modals:close"

    @channel = channel

    #@channel = new App.Models.Channel
      #id: 3
      #image: "https://s3.amazonaws.com/mosey.dev/uploads/cover_art/2/thumb_player_vWrEtJACV5.jpg"
      #title: "a title"
      #description: "a description"
      #slug: "title"
      #follower_count: 35
      #user:
        #name: "jnoh"
      #video:
        #title: "the video title"

    @$el.html @template @channel.toJSON()
    @$el.modal("show")

  close: ->
    @$el.modal("hide")

  #follow
  follow: ->
    @channel.follow()
    App.vent.trigger "channel:followed", @channel

  watch: ->
    App.vent.trigger "channel:watch", @channel
    App.vent.trigger "modals:close"

  followers: ->
    App.vent.trigger "channel:followers", @channel
