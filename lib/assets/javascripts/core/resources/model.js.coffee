namespace "core", ->


    # Base class from which all models should derive.  Implements validation and serialization, together with a DSL for specifying validation and serialization rules.
    #
    class @Model extends core.BaseObject
    
        @include core.ValidatesModule
        

        # @private
        # Convenience method to ensure that @::[attribute_name] exists.
        #
        @_attribute: ( attribute_name ) ->
            @::attributes ?= {}
            @::attributes[attribute_name] ?= {}
            @::attributes[attribute_name]


        # Static method to specify which attributes should be serialized.
        #
        # @param attribute_names [Array<String>] an array of the attribute names which should be serialized.
        #
        # @example
        #   class User extends core.Model
        #     # ...
        #     @attr_serialize "user_name", "email"
        #
        @attr_serialize: ( attribute_names... ) ->
            for attribute_name in attribute_names
                @_attribute( attribute_name ).serialize = true


        # Static method to define an attribute or association.
        #
        # @param attribute_name [String] the name of the attribute.
        # @option opts class_name [String] the name of the class to deserialize the attribute as.
        # @option opts primary_key [Boolean] flag to specifiy whether attribute as the primary key for the underlying resource.
        # @option opts association [Boolean] flag to specify whether the attribute represents an association.
        #
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


        # Builds a one-to-many association with the given name.  Implicitly infers the class name if none is provided.
        #
        # @param association_name [String] the name of the association.
        # @option opts class_name [String] (optional) the name of the underlying class in the association.
        #
        @has_many: ( association_name, opts ) ->
            class_name = opts?.class_name
            class_name ?= core.support.inflector.classify( association_name )
            
            @attr association_name,
                class_name: "List[#{class_name}]"
                association: true


        # Builds a one-to-one association with the given name, and generates a foreign key for the association.
        #
        # @param association_name [String] the name of the association.
        # @option opts class_name [String] (optional) the name of the underlying class in the association.
        #
        @belongs_to: ( association_name, opts ) ->
            @has_one association_name, opts            
            @attr core.support.inflector.foreign_key( association_name )


        # Builds a one-to-one association with the given name.
        #         
        # @param association_name [String] the name of the association.
        # @option opts class_name [String] (optional) the name of the underlying class in the association.
        #
        @has_one: ( association_name, opts ) ->
            class_name = opts?.class_name
            class_name ?= core.support.inflector.camelize( association_name )
            
            @attr association_name,
                class_name: class_name
                association: true                
        
        
        # Instantiates an instance of the model.  Constructs all attributes which aren't associations.
        #
        # @param data [Object] (optional) JSON representation of the initial state of the model.
        # @param env [core.Environment] (optional) the environment to use for serialization.  Defaults to core.Model.default_env.
        #
        constructor: (data, @env) ->
            @env ?= core.Model.default_env
            @deserialize(data || {})
            @_destroy = @env.propertyFactory.createProperty(false)
            @initialize_validator()


        # Returns true if the model has no valid id (i.e. doesn't yet exist in the data repository).
        #
        is_new_record: ->
            !(@id()? and @id() > 0)
        
        
        # Recursively serializes the model and the specified associations, returning a JSON representation of it.
        #
        serialize: (opts) ->
            @env.serialize @class_name, @, opts?.include
            

        # Recursively deserializes the model and the specified associations, returning a reference to the model.
        #
        deserialize: (data) ->
            @env.deserialize @class_name, data, @
        
        
        # Reads the current state of the model from the data repository and updates the model with the result.
        #
        # @param id [Number] the id of the resource to read.
        # @option opts include [String] the associations to include in the response.
        # @option opts success [Function] the handler to call on a successful response.
        # @option opts error [Function] the handler to call in case of an error.
        #
        load: (id, opts) ->
            # env.resourceHandler.get_resource( collName, id, success: success )
            
            self = @
            env = @env
            class_name = @class_name
            collection_name = @collection_name
            
            @id(id)
            
            @env.initialize( class_name, self, opts?.include )
            
            success = (data) ->
                env.deserialize( class_name, data, self )
                opts?.success?( self )
            
            env.repository.get_resource collection_name, id,
                _.defaults success: success, opts
                
            @


        # Reads a collection of models from the data repository and deserializes the response.
        #
        # @param env [core.Environment] the environment to use for deserialization.
        # @option opts success [Function] the handler to call on a successful response.
        # @option opts error [Function] the handler to call in case of an error.
        #
        @load_collection: (env, opts) ->
            class_name = @::class_name
            collection_name = @::collection_name
            success = (data) ->
                collection = _.map data, (el) ->
                    env.deserialize( class_name, el )
                opts?.success?( collection )

            env.repository.get_collection collection_name,
                _.defaults success: success, opts
        
        
        # Saves the model to the data repository, by either creating a new record or updating the existing one.
        #
        # @option opts success [Function] the handler to call on a successful response.
        # @option opts error [Function] the handler to call in case of an error.
        #
        save: ( opts ) ->
            self = @
            env = @env
            opts ?= {}
            collection_name = @collection_name
            
            success = (data) ->
                self.deserialize( data )
                opts?.success?( self )
                
            if @is_new_record()
                env.repository.create_resource collection_name,
                    @serialize(opts),
                    _.defaults success: success, opts
            else
                env.repository.update_resource collection_name,
                    @id(),
                    @serialize(opts),
                    _.defaults success: success, opts
        
        
        # Refreshes the model with recent data from the repository.
        #
        # @option opts success [Function] the handler to call on a successful response.
        # @option opts error [Function] the handler to call in case of an error.
        #
        refresh: ( opts ) ->
            @load( @id(), opts )
            
        destroy: ->
            @_destroy(true)
        
