namespace "core"

# A module to facilitate the specification of dependencies.
#
# @mixin
#
class core.DependentModule

    @dependency: (dependencies, optsFn) ->
        @::dependencies ?= {}
        
        for dependency_name, dependency_type of dependencies
            @::dependencies[dependency_name] = [dependency_type, optsFn]
            
