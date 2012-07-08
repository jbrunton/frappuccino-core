@namespace "core.types", ->

    class @Environment extends core.Mixable    
        @include core.DependentMixin
    
        @dependency propertyFactory: "PropertyFactory"
        
        constructor: ->
            @_types = {}
            @_classes = {}
            @resourceHandler = new core.resources.HttpResourceHandler
        
        defineSimpleType: (tyName, serialize, deserialize) ->
            ty = new core.types.SimpleType tyName, serialize, deserialize
            @_types[tyName] = ty
            ty
            
        defineComplexType: (tyName, tyDef, tyClass) ->
            ty = new core.types.ComplexType tyName, tyDef, @propertyFactory
            @_types[tyName] = ty
            @_classes[tyName] = tyClass
            ty
            
        defineResource: (tyName, collName, tyDef) ->
            @defineComplexType tyName, tyDef, core.resources.Resource(tyName, collName)
            
        getType: (tyName) ->
            match = /^List\[(.*)\]$/.exec tyName
            if match?
                [_, listElemTyName] = match
                new core.types.ListType (@getType listElemTyName), @propertyFactory
            else
                if not @_types[tyName]
                    throw new Error "Type #{tyName} does not exist in environment"
                @_types[tyName]
                
        load_collection: (ty_name, opts) ->
            resource = @_classes[ty_name]
            resource.load_collection( @, opts )
        
        serialize: (tyName, obj, includeSpec) ->
            ty = @getType tyName
            ty.serialize obj, this, includeSpec
            
        deserialize: (tyName, data, target) ->
            ty = @getType tyName
            ty.deserialize data, this, target
            
        create: (tyName, opts...) ->
            tyClass = @_classes[tyName]
            if tyClass?
                new tyClass @, opts
            else
                {}
        
        ###
        url: ({ res, type, id, action }) ->
            if res?
                for.url( action )
            else
                ty_class = @_classes[type]
                ty_class.url( id, action )
        ###