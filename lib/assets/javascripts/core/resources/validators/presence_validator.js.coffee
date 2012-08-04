namespace "core.validators", ->

    class @PresenceValidator
    
        constructor: ( @attribute, @opts ) ->
            @message = @opts?.message
            @message ?= "please provide a value for #{@attribute}"
                    
        validate: ( model ) ->
            unless model[@attribute] and model[@attribute]()
                model[@attribute].errors.push( @message )