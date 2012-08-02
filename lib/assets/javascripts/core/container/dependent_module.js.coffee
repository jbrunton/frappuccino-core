namespace "core", ->

    class @DependentModule
    
        constructor: ->
            # @::_dependencies = @::_dependencies ?= {}
            
    
        @dependency: (dependencies, optsFn) ->
            @::_dependencies = @::_dependencies ?= {}
            
            # TODO: assert obj has one field?
            
            for dependency_name, dependency_type of dependencies
                @::_dependencies[dependency_name] = [dependency_type, optsFn]
                
    class @DependentObject extends core.BaseObject
        @include core.DependentModule