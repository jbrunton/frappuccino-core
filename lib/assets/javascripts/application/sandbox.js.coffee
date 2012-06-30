namespace "core", ->

    class @Sandbox extends core.Mixable
        @include core.DependentMixin
    
        @dependency mediator: "Mediator"
        @dependency renderer: "Renderer"
        
        constructor: (@module) ->
        
        publish: (eventName, args...) ->
            @mediator.publish(eventName, args...)
            
        bind: (obj) ->
            regex = /^@((\w+)\.)?(\w+)$/

            for eventName, handler of obj when eventName[0] == "@"
                match = regex.exec eventName
                scope = match[2] ?= @module.name
                event = match[3]

                fullEventName = "#{scope}.#{event}"
                @mediator.subscribe fullEventName, handler, obj
