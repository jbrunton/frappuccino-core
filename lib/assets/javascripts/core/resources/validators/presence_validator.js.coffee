namespace "core.validators"

class core.validators.PresenceValidator extends core.validators.BaseValidator

    constructor: ( attribute, opts ) ->
        super( attribute, opts )
        #TODO repleace literal assignment of message with a call to initialize_attributes
        #@initialize_attributes(opts , "message")
        @message = opts?.message
        @message ?= @default_message()

    default_message: ->
        "please provide a value for #{@attribute}"

    validate: ( model ) ->
        input = @attribute_value( model )
        unless input? and input.length > 0
            @error( model, @message )