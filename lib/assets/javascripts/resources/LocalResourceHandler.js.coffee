namespace "core.resources", ->

    class @LocalResourceHandler
    
        constructor: ->
            @_collections = {}
            @_sequences = {}
            
        _getCollection: (collName) ->
            unless @_collections[collName]?
                @_collections[collName] = {}
                @_sequences[collName] = 0

            @_collections[collName]
            
        _getNextSeq: (collName) ->
            ++@_sequences[collName]
            
        get_resource: (collName, id, { success, error, opts } = { success: null, error: null, opts: null }) ->
            collection = @_getCollection(collName)
            success?( core.util.clone( collection[id] ) )
        
        createResource: (collName, data, { success, error, opts } = { success: null, error: null, opts: null }) ->
            collection = @_getCollection(collName)
            data.id = @_getNextSeq collName
            success?( collection[data.id] = core.util.clone( data ) )
        
        updateResource: (collName, data, { success, error, opts } = { success: null, error: null, opts: null }) ->
            collection = @_getCollection(collName)
            res = collection[data.id]
            for key, value of data
                res[key] = core.util.clone value
            success?( core.util.clone( res ) )
            