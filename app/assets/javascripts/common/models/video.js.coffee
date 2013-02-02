App.Models.Video = Backbone.View.extend

  create: (action,links) ->
    @deferred = $.Deferred()

    get = $.ajax
      url: "#{action}.json"
      type: "POST"
      data:
        links: links

    get.done (results) =>
      @checkStatus(results.job)

    @deferred

  checkStatus: (id) ->
    get = $.ajax
      url: "/me/request/status/add_video?id=#{id}"
      type: "GET"

    get.done (results) =>
      if results.status? and results.status != "pending"
        if results.status == "success"
          @deferred.resolve results.msg
        else
          @deferred.reject results.msg
      else
        callback = =>
          @checkStatus(id)
        window.setTimeout callback, 1000



