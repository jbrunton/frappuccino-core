namespace "core", ->

    class @Mediator
    
        constructor: ->
            @_channels = {}
        
        subscribe: (event, handler, context) ->
            @_channels[event] = [] unless @_channels[event]?            
            @_channels[event].push(-> handler.apply( context, arguments ) )
        
        publish: (eventName, args...) ->
            channels = @_channels?[eventName]
            for handler in channels ?= {}
                handler(args...)