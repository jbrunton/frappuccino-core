namespace "core"

# An implementation of the mediator pattern.  This class should not be referred to directly, as the AER pattern is preferred.
#
class core.Mediator

    constructor: ->
        @_channels = {}

    # Subscribes the given handler to the content for the specified event.
    #
    subscribe: ( event, handler, context ) ->
        @_channels[event] ?= []
        @_channels[event].push(-> handler.apply( context, arguments ) )

    # Invokes all handlers for the specified event.
    #
    publish: ( event, args... ) ->
        channels = ( @_channels?[event] || {} )
        for handler in channels
            handler( args... )