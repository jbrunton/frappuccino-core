namespace "core", ->

    class @Model
    
        @_attr_accessible: []
        @_attr = {}
    
        @attr_accessible: ->
            @_attr_accessible = @_attr_accessible.concat( _.toArray( arguments ) )
            
        @attr: ( attr ) ->
            @_attr = _.defaults( @_attr, attr )
            
        @ty_def: ->
            { attr: @_attr, attr_accessible: @_attr_accessible }
            
        
        constructor: (@env, data) ->
                @deserialize(data || {})
                
        serialize: ->
            @env.serialize @class_name, @
            
        deserialize: (data) ->
            @env.deserialize @class_name, data, @
        
        load: (id, opts) ->
            # env.resourceHandler.get_resource( collName, id, success: success )
            
            self = @
            env = @env
            class_name = @class_name
            collection_name = @collection_name
            
            @id(id)
            
            success = (data) ->
                env.deserialize( class_name, data, self )
                opts?.success?( self )
            
            env.resourceHandler.get_resource collection_name, id,
                _.defaults success: success, opts
                
            @

        @load_collection: (env, opts) ->
            class_name = @::class_name
            collection_name = @::collection_name
            success = (data) ->
                collection = _.map data, (el) ->
                    env.deserialize( class_name, el )
                opts?.success?( collection )

            env.resourceHandler.get_collection collection_name,
                _.defaults success: success, opts
        
        save: ( opts ) ->
            self = @
            env = @env
            opts ?= {}
            collection_name = @collection_name
            
            success = (data) ->
                self.deserialize( data )
                opts?.success?( self )
                
            if @id()
                env.resourceHandler.update_resource collection_name,
                    @id(),
                    @serialize(),
                    _.defaults success: success, opts
            else
                env.resourceHandler.create_resource collection_name,
                    @serialize(),
                    _.defaults success: success, opts
                    
        refresh: ( opts ) ->
            @load( @id(), opts )
