namespace "core"

# Provides convenience methods @on and publish for subscribing and publishing to application events with AER.
#
class core.EventsModule

    # Generates a named event handler for AER.
    #
    # @param event [String] the name of the event.
    # @param handler [Function] the event handler.
    #
    @on: ( event, handler ) ->
        @::["@#{event}"] = handler

    # Publishes an event through the sandbox.
    #
    # @param event [String] the name of the event.
    # @param args [Array] the arguments to pass to the handler.
    #
    publish: ( event, args ) ->
        @sandbox.publish( event, args )
            
