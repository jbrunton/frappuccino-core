namespace "core", ->

    class @DependentMixin
    
        constructor: (mixin) ->
            # @::_dependencies = @::_dependencies ?= {}
            
    
        @dependency: (obj, optsFn) ->
            @::_dependencies = @::_dependencies ?= {}
            
            # TODO: assert obj has one field?
            
            for key, value of obj
                @::_dependencies[key] = [value, optsFn]