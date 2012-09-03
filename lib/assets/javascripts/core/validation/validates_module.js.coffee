namespace "core"

errorsArray = ->
    if ko?
        errors = ko.observableArray([])
    else
        xs = []
        errors = ->
            if arguments.length == 0
                xs
            else
                xs = arguments[0]
        errors.push = (x) -> xs.push(x)
    errors



class ModelValidator

    constructor: ->
        @validators = {}

    enum_attributes: ->
        _.unique(
            _.flatten(
                _.map( @validators, (validator) ->
                    validator.enum_attributes()
                ) ) )
        
    validate: ( model ) ->
        for attribute_name in @enum_attributes()
            model[attribute_name].errors([])
        for attr_name, attr_validator of @validators
            if attr_validator.should_validate( model )
                attr_validator.validate( model )
                
    validate_attribute: ( model, attribute_name ) ->
        @validators[attribute_name].validate( model )
        
    add_attribute_validator: ( validator ) ->
        @validators[validator.attribute_name] = validator
        
    initialize_model: ( model ) ->
        for attr_name, attr_validator of @validators
            attr_validator.initialize_model( model )
            
        for attr_name in @enum_attributes()
            @initialize_attribute( model, attr_name )
            
    initialize_attribute: ( model, attribute_name ) ->
        errors = errorsArray()
        model[attribute_name].errors = errors

        is_valid = ( -> errors().length == 0 )
        model[attribute_name].is_valid = if ko? then ko.computed(is_valid, model) else is_valid

class AttributeValidator
    
    add_validator: ( validator_name, opts ) ->
        validator_class_name = "#{core.support.inflector.camelize( validator_name )}Validator"
        validator = new core.validators[validator_class_name]( @attribute_name, opts )
        @validators.push( validator )

    parse_opts: ( opts ) ->
        validators = _.clone(opts)
        if opts.if?
            validate_if = opts.if
            delete validators.if
        if opts.unless?
            validate_unless = opts.unless
            delete validators.unless
        { validate_if: validate_if, validate_unless: validate_unless, validators: validators }
            
        
                                
    constructor: ( @attribute_name, opts ) ->
        opts = @parse_opts( opts )
        @validate_if = opts.if_cond
        @validate_unless = opts.unless_cond
        @validators = []
        for validator_name, validator_opts of opts.validators
            @add_validator( validator_name, validator_opts )
                                
    initialize_model: ( model ) ->
        for validator in @validators
            validator.initialize_model( model )

    should_validate: ( model ) ->
        ( not @validate_if and not @valdiate_unless ) or
            ( @validate_if and @validate_if( model ) ) or
                ( @validate_unless and @validate_unless( model ) )
        
    validate: ( model ) ->
        for validator in @validators
            validator.validate( model )
            
    enum_attributes: ->
        _.unique(
            _.flatten(
                _.map( @validators, (validator) ->
                    validator.enum_attributes()
                ) ) )


# A mixin for objects which wish to use the validators API.
#
class core.ValidatesModule

    
    # Specifies validation on a named attribute.
    #
    # @param attribute_name [String] the name of the attribute to validate.
    # @param opts [Object] a hash of the validators to invoke and options to pass to each.
    #
    # @example requires a user_name:
    #   class User extends core.model
    #     # ...
    #     @validates "user_name", presence: true, length: { min: 5 }
    #
    @validates: ( attribute_name, opts ) ->
        @::model_validator ?= new ModelValidator
        attribute_validator = new AttributeValidator( attribute_name, opts )
        @::model_validator.add_attribute_validator( attribute_validator )
    
    
    # Initializes the model for the validators API (by delegating to ModelValidator.initialize_model).
    #
    initialize_validator: ->
        @model_validator.initialize_model( @ ) unless not @model_validator?


    # Adds the given error to the model or attribute.
    #
    # @param message [String] the error message.
    # @param attribute_name [String] (optional) the attribute to invalidate.  If none is specified, the error is added to the model instead.
    #
    validation_error: ( message, attribute_name ) ->
        if attribute_name?
            @[attribute_name].errors.push( message )
        else
            @errors.push( message )


    # Validates the given attribute.
    #
    # @param attribute_name [String] the name of the attribute.
    # @return [Boolean] returns true if the attribute is valid.
    #
    validate_attribute: ( attribute_name ) ->
        @model_validator?.validate_attribute( @, attribute_name )
        @[attribute_name].is_valid()
    
    
    # Validates the model.
    #
    # @return [Boolean] returns true if the model is valid.
    #
    validate: ->
        @model_validator?.validate( @ )
        @is_valid()

#        validate: ->
#            if  @validated_attributes
#                for attribute in @validated_attributes
#                    @[attribute].errors([])
#                
#            if @validators
#                for validator in @validators
#                    if ( not validator.if? and not validator.unless? ) or
#                        ( validator.if? and validator.if( @ ) ) or
#                        ( validator.unless? and !validator.unless( @ ) )
#                            validator.validate( @ )
    
    
    # Returns the current validation state of the model.  Note that this method does not revalidate the model.
    #
    # @return [Boolean] the current validation state.
    #
    is_valid: ->
        model = @
        _.every @model_validator.enum_attributes(),
            ( attr ) -> model[attr].is_valid()            
    
    
    constructor: ->
        @errors = new core.ModelErrors
