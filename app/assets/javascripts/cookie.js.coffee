if typeof(window.App) == "undefined" then window.App = {}

$.extend window.App, 
  cookie:
    set: (name, value, expiredays) ->
      console.log "Set cookie: #{name} = #{value}"
      expiration = new Date()
      expiration.setDate expiration.getDate() + expiredays
      document.cookie = name + "=" + escape(value) +
        (if expiredays? then "" else ";expires=" + expiration.toUTCString()) +
        '; path=/'
        
    get: (name) ->
      if document.cookie.length > 0
        start = document.cookie.indexOf name + "="
        
        if start isnt -1
          start = start + name.length + 1
          end = document.cookie.indexOf ";", start
          
          if end is -1 then end = document.cookie.length
          return unescape(document.cookie.substring start, end)
      return ""
