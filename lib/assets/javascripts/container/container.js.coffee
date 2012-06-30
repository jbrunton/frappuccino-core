namespace "core", ->

    class @Container
    
        constructor: (parent) ->
            @_mappings = {}
            @_parent = parent
            
        _register_mapping: (name, ref, kind, opts = {}) ->
            @_mappings[name] = _.defaults( { kind: kind, ref: ref }, opts )
            
        _resolve_dependencies: (target, properties) ->
            for name, [dependency, optsFn] of properties
                if typeof dependency == "function"
                    target[name] = dependency.apply(target, [@])
                else
                    target[name] = @resolve dependency, optsFn?.apply(target)
        
        register_class: (name, klass, opts = {}) ->
            @_register_mapping name, klass, "class", opts
            @
        
        register_instance: (name, obj) ->
            @_register_mapping name, obj, "instance"
            @
            
        resolve_class: (name) ->
            mapping = @_mappings[name]
            
            # if mapping.kind != "class"
            # TODO: error
            
            mapping.ref
            
        resolve: (ref, opts) ->
            if typeof ref == "string"
                mapping = @_mappings[ref]
                
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
                
        child: ->
            new Container @
            