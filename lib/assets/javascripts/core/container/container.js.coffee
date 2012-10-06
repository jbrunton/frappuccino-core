namespace "core"

# Implementation of a DI container.
#
class core.Container

    # Creates an instance of a container.
    #
    # @param parent [core.Container] a parent container. When provided, if resolution of a dependency fails then resolution will be attempted with the parent container instead.
    #
    constructor: (@parent) ->
        @_mappings = {}
    
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
        target

    # Registers a class mapping with the container.
    #
    # @param name [String] the name of the mapping to the class.
    # @param klass [Class] the class the dependency should resolve with.
    # @option opts [Boolean] singleton indicates whether the resolved dependency should be memoized.
    # @return [Container] the container.
    #
    register_class: (name, klass, opts = {}) ->
        @_register_mapping name, klass, "class", opts
        @
    
    
    # Registers an instance mapping with the container.
    #
    # @param name [String] the name of the mapping to the instance.
    # @param obj [Object] the instance the dependency should resolve to.
    # @return [Container] the container.
    #
    register_instance: (name, obj) ->
        @_register_mapping name, obj, "instance"
        @


    # Resolves a dependency by name.
    #
    # @private
    # @param name [String] the name of the dependency.
    # 
    _resolve_string: ( name, opts ) ->
        mapping = @_mappings[name]
        return null unless mapping?
        
        if mapping.kind == "instance"
            mapping.ref
        else if mapping.kind == "class" and mapping.singleton == true
            mapping.instance = @resolve( mapping.ref, opts ) unless mapping.instance?
            mapping.instance
        else
            @resolve( mapping.ref, opts )


    # Resolves a dependency specified by a function.
    # 
    # @private
    # @param 
    #
    _resolve_function: ( fn, opts ) ->
        opts ?= {}
        obj = new fn( opts )
        @resolve obj
        
    # Resolves dependencies on the target object.
    #
    # @param target [Object] the target object.
    #
    _resolve_object: ( target ) ->
        @_resolve_dependencies target, target.dependencies
    
    # Returns an instance of the given dependency, resolving any child dependencies.
    #
    # @overLoad resolve(name)
    #   Resolves the dependency according to the name of the mapping.
    #   @param name [String] the name of the dependency mapping.
    #   @return [Object] the fully resolved dependency.
    #
    # @overLoad resolve(target, opts)
    #   Resolves any unresolved dependencies on a given object.
    #   @param target [Object] the object to resolve dependencies for.
    #   @return [Object] target.
    # 
    resolve: (args...) ->
        [ref, opts] = args
        if typeof ref == "string"
            resolution = @_resolve_string( ref, opts )
        else if typeof ref == "function"
            resolution = @_resolve_function( ref, opts )
        else if typeof ref == "object"
            resolution = @_resolve_object( ref )
        
        if resolution?
            resolution
        else if @parent?
            @parent.resolve ref, opts unless resolution?
        else
            throw new Error( "Unable to resolve dependency: #{ref}" ) unless resolution?
    
    # Creates a child container.
    # @return [Container] a new child container.
    #
    child: ->
        new Container( @ )
