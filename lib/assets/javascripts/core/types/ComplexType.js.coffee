@namespace "core.types", ->

    class @ComplexType
    
        constructor: (@tyName, @tyDef, @propertyFactory) ->
            @kind = "complex"
        
        serialize: (obj, env, includeSpec) ->
        
            data = {}
            tyDef = @tyDef
            includeSpec = includeSpec ?= {}
            
            serializeField = (propName, propDef) ->
                propTyName = propDef.ty_name
                propTy = env.getType propTyName
                propKind = propTy.kind # TODO: don't need this var
                include = propDef.accessible || includeSpec[propName]?
                
                if include
                    prop = obj[propName]
                    propVal = prop() unless not prop
                    
                    if propDef.association
                        propName = "#{propName}_attributes"
                    
                    data[propName] = propTy.serialize propVal, env, includeSpec[propName]
            
            for propName, propTyName of tyDef.attr
                serializeField propName, propTyName
            
            data
            
        deserialize: (data, env, target) ->
        
            target = target ?= env.create(@tyName)
            tyDef = @tyDef
            self = @
            
            if !data?
                return target
            
            deserializeField = (propName, propDef) ->
                propTyName = propDef.ty_name
                propTy = env.getType propTyName
                propKind = propTy.kind # TODO: don't need this var
                propVal = propTy.deserialize data[propName], env
                if target[propName]?
                    target[propName]( propVal )
                else
                    if propKind == "list"
                        prop = self.propertyFactory.createArrayProperty propVal
                    else
                        prop = self.propertyFactory.createProperty propVal
                
                    target[propName] = prop
            
            for propName, propTyName of tyDef.attr
                deserializeField propName, propTyName 
            
            target