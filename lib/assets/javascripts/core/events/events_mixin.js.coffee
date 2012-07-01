namespace "core", ->

    class @EventsMixin
    
        @on: (eventName, handler) ->
            handlerName = "@#{eventName}"
            @::[handlerName] = handler
            
        #fire: (eventName, args) ->
        #    @sandbox.fire(eventName, args)

        publish: (eventName, args) ->
            @sandbox.publish eventName, args