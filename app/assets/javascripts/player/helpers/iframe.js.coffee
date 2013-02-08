if typeof(window.App) == "undefined" then window.App = {}


class App.IframeReceiver
  # register available methods
  constructor: (funtions) ->
    @_available = functions

  callMethod: (fnName, args) ->
    if @_available[fnName]?
      @_available[fnName].apply(this, args)

class App.IframeSender
  # first arg is function name. last args are the remainging ones.
  callParent: () ->
    args = Array.prototype.slice.call(arguments)
    fnName = args.shift()
    if top? and top.callMethod?
      top.callMethod(fnName, args)


sender = new App.IframeSender


