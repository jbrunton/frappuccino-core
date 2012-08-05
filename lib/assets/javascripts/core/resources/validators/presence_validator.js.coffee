namespace "core.validators", ->

    class @PresenceValidator extends core.validators.BaseValidator
    
        constructor: ( attribute, opts ) ->
            super( attribute, opts )
            @message = opts?.message
            @message ?= @default_message()
                    
        default_message: ->
            "please provide a value for #{@attribute}"
    
        validate: ( model ) ->
            unless @attribute_value( model )?
                @error( model, @message )