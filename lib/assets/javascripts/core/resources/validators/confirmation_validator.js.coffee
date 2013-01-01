namespace "core.validators"

class core.validators.ConfirmationValidator extends core.validators.BaseValidator

    constructor: ( attribute, opts ) ->
        super( attribute, opts )
        @confirmation_attribute = "#{@attribute}_confirmation"
        @initialize_attributes(opts , "message")
        @message ?= "values do not match"
        
    initialize_model: ( model ) ->
        model[@confirmation_attribute] = ko.observable()
        
    enum_attributes: ->
        attributes = super()
        attributes.push( @confirmation_attribute )
        attributes
                
    validate: ( model ) ->
        input = @attribute_value( model )
        return unless input?
        confirmation_input = @attribute_value( model, @confirmation_attribute )
        unless input == confirmation_input
            @error( model, @message, @confirmation_attribute )
                