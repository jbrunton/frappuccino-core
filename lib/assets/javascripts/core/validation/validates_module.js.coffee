namespace "core", ->

    class @ValidatesModule
    
        @add_validator: ( attribute, validator_name, validator_opts ) ->
            validator_class_name = "#{core.support.inflector.camelize( validator_name )}Validator"
            validator = new core.validators[validator_class_name]( attribute, validator_opts )
            @::validators ?= []
            @::validators.push( validator )
            @::validated_attributes ?= []
            unless _.include( @::validated_attributes, attribute )
                @::validated_attributes.push( attribute )
            
        @validates: ( attribute, validators ) ->
            for validator_name, validator_opts of validators
                @add_validator( attribute, validator_name, validator_opts )
                
        initialize_validators: ->
            for attribute in @validated_attributes
                errors = ko.observableArray([])
                @[attribute].errors = errors

                is_valid = -> errors().length == 0
                @[attribute].is_valid = ko.computed(is_valid, @)
            
        validate: ->
            if  @validated_attributes
                for attribute in @validated_attributes
                    @[attribute].errors([])
                
            if @validators
                for validator in @validators
                    validator.validate( @ )
                
        is_valid: ->
            model = @
            @validate()
            _.every @validated_attributes,
                ( attr ) -> model[attr].is_valid()            
        
        constructor: ->
            @errors = new core.ModelErrors