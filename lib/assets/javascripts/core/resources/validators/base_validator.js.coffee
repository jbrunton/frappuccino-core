namespace "core.validators", ->

    class @BaseValidator
    
        constructor: ( @attribute, opts ) ->
            @if = opts?.if
            @unless = opts?.unless
    
        initialize_model: ( model ) ->
        
        attribute_value: ( model, attribute_name ) ->
            attribute_name ?= @attribute
            if model[attribute_name]?
                model[attribute_name]()
                
        enum_attributes: ->
            [ @attribute ]
                
        error: ( model, message, attribute_name ) ->
            attribute_name ?= @attribute
            model[attribute_name].errors.push( @message )
        