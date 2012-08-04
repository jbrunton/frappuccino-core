namespace "core.validators", ->

    class @PresenceValidator
    
        constructor: ( @attribute, @message ) ->
            @message ?= "please provide a value for #{@attribute}"
        
        validate: ( model ) ->
            unless model[@attribute] and model[@attribute]()
                model.errors.add( @attribute, @message )
            