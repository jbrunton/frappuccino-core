namespace "core"

# Implementation of a DI container.
#
class core.Container

    # Creates an instance of a container.
    #
    # @param parent [core.Container] a parent container. When provided, if resolution of a dependency fails then resolution will be attempted with the parent container instead.
    #
    constructor: (parent) ->
        @_mappings = {}
        @_parent = parent
    
    # @private
    #
    _register_mapping: (name, ref, kind, opts = {}) ->
        @_mappings[name] = _.defaults( { kind: kind, ref: ref }, opts )

    # @private
    #        
    _resolve_dependencies: (target, properties) ->
        for name, [dependency, optsFn] of properties
            if typeof dependency == "function"
                target[name] = dependency.apply(target, [@])
            else
                target[name] = @resolve dependency, optsFn?.apply(target, [@])


    # Registers a class mapping with the container.
    #
    # @param name [String] the name of the mapping to the class.
    # @param klass [Class] the class the dependency should resolve with.
    # @option opts [Boolean] singleton indicates whether the resolved dependency should be memoized.
    #
    register_class: (name, klass, opts = {}) ->
        @_register_mapping name, klass, "class", opts
        @
    
    
    # Registers an instance mapping with the container.
    #
    # @param name [String] the name of the mapping to the instance.
    # @param obj [Object] the instance the dependency should resolve to.
    #
    register_instance: (name, obj) ->
        @_register_mapping name, obj, "instance"
        @
    
    # TODO: is this method really needed?  Seems kinda hacky.
    resolve_class: (name) ->
        mapping = @_mappings[name]
        
        # if mapping.kind != "class"
        # TODO: error
        
        mapping.ref
    
    # Returns an instance of the given dependency, resolving any child dependencies.
    #
    # @overLoad resolve(name)
    #   Resolves the dependency according to the name of the mapping.
    #   @param name [String] the name of the dependency mapping.
    #
    # @overLoad resolve(target, opts)
    #   Resolves any unresolved dependencies on a given object.
    #   @param target[Object] the object to resolve dependencies for.
    # 
    resolve: (args...) ->
        [ref, opts] = args
        if typeof ref == "string"
            mapping = @_mappings[ref]
            
            if !mapping
                return null
            
            if mapping.kind == "instance"
                mapping.ref
            else if mapping.kind == "class" and mapping.singleton == true
                if mapping.instance?
                    mapping.instance
                else
                    mapping.instance = @resolve(mapping.ref, opts)
            else
                @resolve(mapping.ref, opts)
        else if typeof ref == "function"
            obj = new ref (opts ?= {})
            @resolve obj
        else if typeof ref == "object"
            @_resolve_dependencies ref, ref._dependencies
            ref
        else if @_parent?
            @_parent.resolve ref, opts
        else
            # TODO: error
    
    # Creates a child container.
    #
    child: ->
        new Container( @ )
