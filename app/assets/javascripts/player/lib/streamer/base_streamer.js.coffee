# base streamer is used by the player to play a series of videos

class App.BaseStreamer
  constructor: ->

  # returns promise with App.Models.Airing
  start: (id) ->
    throw "please extend start"

  # returns App.Models.Airing
  next: ->
    throw "please extend next"
