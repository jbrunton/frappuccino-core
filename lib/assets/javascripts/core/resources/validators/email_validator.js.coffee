namespace "core.validators", ->

    class @EmailValidator extends core.validators.BaseValidator
    
        constructor: ( @attribute, opts ) ->
            @message = opts?.message
            @message ?= "please provide a valid email address"
                    
        validate: ( model ) ->
            input = @attribute_value( model )
            return unless input?
            unless /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/.test(input)
                @error( model, @message )