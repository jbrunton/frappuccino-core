namespace "core.validators", ->

    class @BaseValidator
    
        initialize: ( model ) ->
        
        attribute_value: ( model ) ->
            if model[@attribute]?
                model[@attribute]()
                
        error: ( model, message ) ->
            model[@attribute].errors.push( @message )
        