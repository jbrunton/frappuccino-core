namespace "core.validators"

class core.validators.BaseValidator

    constructor: ( @attribute, opts ) ->
        @if = opts?.if
        @unless = opts?.unless

    initialize_model: ( model ) ->

    initialize_attributes: ( opts , args... ) ->
        if opts? and _.isObject(opts)
            _.extend( this , _.pick.apply( this, [opts, args] ) )
    
    attribute_value: ( model, attribute_name ) ->
        attribute_name ?= @attribute
        if model[attribute_name]?
            model[attribute_name]()
            
    enum_attributes: ->
        [ @attribute ]
            
    error: ( model, message, attribute_name ) ->
        attribute_name ?= @attribute
        model.validation_error( @message, attribute_name )
        