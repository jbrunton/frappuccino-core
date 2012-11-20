namespace "core.validators"

class core.validators.EmailValidator extends core.validators.BaseValidator

    constructor: ( attribute, opts ) ->
        super( attribute, opts )
        @initialize_attributes(opts , "message")
        @message ?= "please provide a valid email address"
                
    validate: ( model ) ->
        input = @attribute_value( model )
        return unless input?
        unless /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/.test(input)
            @error( model, @message )