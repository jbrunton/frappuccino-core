namespace "core.validators", ->

    class @FormatValidator extends core.validators.BaseValidator
    
        constructor: ( @attribute, opts ) ->
            @format = opts.with
            @message = opts?.message
            @message ?= "input must be in the specified format"
                    
        validate: ( model ) ->
            input = @attribute_value( model )
            return unless input?
            unless @format.test(input)
                @error( model, @message )