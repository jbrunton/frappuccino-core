namespace "core", ->

    class @Model extends core.BaseObject
    
        @include core.ValidatesModule
        
        # convenience method to ensure that @::[attribute_name] exists
        @_attribute: ( attribute_name ) ->
            @::attributes ?= {}
            @::attributes[attribute_name] ?= {}
            @::attributes[attribute_name]
    
        @attr_serialize: ->
            for attribute_name in arguments
                @_attribute( attribute_name ).serialize = true
            
        @attr: ( attribute_name, opts ) ->
            class_name = opts?.class_name
            class_name ?= "Inherit"

            primary_key = opts?.primary_key
            primary_key ?= attribute_name == "id"
            
            association = opts?.association
            
            attribute = @_attribute( attribute_name )
            attribute.class_name = class_name
                
            attribute.primary_key = true unless !primary_key
            attribute.association = true unless !association
                        
        @has_many: ( association_name, opts ) ->
            class_name = opts?.class_name
            class_name ?= core.support.inflector.classify( association_name )
            
            @attr association_name,
                class_name: "List[#{class_name}]"
                association: true
                
        @belongs_to: ( association_name, opts ) ->
            @has_one association_name, opts            
            @attr core.support.inflector.foreign_key( association_name )
                
        @has_one: ( association_name, opts ) ->
            class_name = opts?.class_name
            class_name ?= core.support.inflector.camelize( association_name )
            
            @attr association_name,
                class_name: class_name
                association: true                
        
        constructor: (data, @env) ->
            @env ?= core.Model.default_env
            @deserialize(data || {})
            @initialize_validator()

        is_new_record: ->
            !(@id()? and @id() > 0)
                
        serialize: (opts) ->
            @env.serialize @class_name, @, opts?.includes
            
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
            
            env.repository.get_resource collection_name, id,
                _.defaults success: success, opts
                
            @

        @load_collection: (env, opts) ->
            class_name = @::class_name
            collection_name = @::collection_name
            success = (data) ->
                collection = _.map data, (el) ->
                    env.deserialize( class_name, el )
                opts?.success?( collection )

            env.repository.get_collection collection_name,
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
                env.repository.update_resource collection_name,
                    @id(),
                    @serialize(opts),
                    _.defaults success: success, opts
            else
                env.repository.create_resource collection_name,
                    @serialize(opts),
                    _.defaults success: success, opts
                    
        refresh: ( opts ) ->
            @load( @id(), opts )
            
        
        # form methods
        
#        forms: ( form_name ) ->
#            @_forms[form_name] ?= {}
#            @_forms[form_name]
#        
#        copy_attribute: ( attribute_name ) ->
#            # TODO: refactor this method
#            ko.observable( @[attribute_name]() )
#        
#        field_for: ( form_name, attribute ) ->
#            form = @forms( form_name )
#            form[attribute] = @copy_attribute( attribute )            
#        
#        action_for: ( form_name, action ) ->
#            form = @forms( form_name )
#        
#        form_for: ( form_name, callback ) ->
#            model = @
#            form =
#                field: ( attribute ) ->
#                    model.field_for( form_name, attribute )
#                    
#                fields: ( fields... ) ->
#                    for field in fields
#                        model.field_for( form_name, field )
#                
#                action: ( action ) ->
#                    model.action_for( form_name, action )
#                    
#                actions: ( actions... ) ->
#                    for action in actions
#                        model.action_for( form_name, action )
#            callback( form )
