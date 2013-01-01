namespace "core.validators"

class core.validators.PresenceValidator extends core.validators.BaseValidator

    constructor: ( attribute, opts ) ->
        super( attribute, opts )
        @initialize_attributes(opts , "message")
        @message ?= @default_message()

    default_message: ->
        "please provide a value for #{@attribute}"

    validate: ( model ) ->
        input = @attribute_value( model )
        unless input? and input.length > 0
            @error( model, @message )