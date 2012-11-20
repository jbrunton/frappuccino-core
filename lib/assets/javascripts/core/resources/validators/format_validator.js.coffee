namespace "core.validators"

class core.validators.FormatValidator extends core.validators.BaseValidator

    constructor: ( attribute, opts ) ->
        super( attribute, opts )
        @format = opts.with
        @initialize_attributes(opts , "message")
        @message ?= "input must be in the specified format"
                
    validate: ( model ) ->
        input = @attribute_value( model )
        return unless input?
        unless @format.test(input)
            @error( model, @message )