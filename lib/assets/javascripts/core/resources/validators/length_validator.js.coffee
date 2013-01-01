namespace "core.validators"

class core.validators.LengthValidator extends core.validators.BaseValidator

    constructor: ( attribute, opts ) ->
        super( attribute, opts )
        @initialize_attributes(opts , "min", "max", "message")
        @message ?= @default_message()
                
    default_message: ->
        if @min?
            if @max?
                "please enter between #{@min} and #{@max} characters"
            else
                "please enter at least #{@min} characters"
        else
            "please enter at most #{@max} characters"
                
    validate: ( model ) ->
        input = @attribute_value( model )
        return unless input?
        if ( @min? and input.length < @min ) or
            ( @max? and input.length > @max )
                @error( model, @message )