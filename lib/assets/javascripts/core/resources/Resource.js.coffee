namespace "core.resources", ->

    @Resource = (type_name, collection_name) ->
        class
        
            type_name: type_name
            
            collection_name: collection_name
            
            constructor: (@env, data) ->
                @deserialize(data || {})
                
            serialize: ->
                @env.serialize type_name, @
                
            deserialize: (data) ->
                @env.deserialize type_name, data, @
            
            load: (id, opts) ->
                # env.resourceHandler.get_resource( collName, id, success: success )
                
                self = @
                env = @env
                
                @id(id)
                
                success = (data) ->
                    env.deserialize( type_name, data, self )
                    opts?.success?( self )
                
                env.resourceHandler.get_resource collection_name, id,
                    _.defaults success: success, opts
                    
                @
            
            save: ( opts ) ->
                self = @
                env = @env
                opts ?= {}
                
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
