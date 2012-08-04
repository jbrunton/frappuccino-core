namespace "core", ->

    class @ValidatesModule
    
        @add_validator: ( attribute, validator_name, validator_opts ) ->
            validator_class_name = "#{core.support.inflector.camelize( validator_name )}Validator"
            validator = new core.validators[validator_class_name]( attribute, validator_opts )
            @::validators ?= []
            @::validators.push( validator )
            
        @validates: ( attribute, validators ) ->
            for validator_name, validator_opts of validators
                @add_validator( attribute, validator_name, validator_opts )
                
        validate: ->
            @errors.clear()
            if @validators
                for validator in @validators
                    validator.validate( @ )
                
        is_valid: ->
            @validate()
            @errors.count == 0
            
        constructor: ->
            @errors = new core.ModelErrors