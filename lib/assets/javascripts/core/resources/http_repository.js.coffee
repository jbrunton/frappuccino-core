namespace "core.resources"


# Repository for making async HTTP requests to a RESTful API.
# 
class core.resources.HttpRepository


    # Generates the URL to access a RESTful collection or resource.
    #
    # @param collection_name [String] the name of the collection.
    # @param id [String] (optional) the id of the resource.
    # @param includes [Object] (optional) the associations to follow and include in the response.
    # @param action [String] (optional) the action to append to the collection URL.
    # @return [String] the full URL.
    #
    # @example a collection of all users:
    #   repository.resource_url( "users" ) # "/api/users/"
    # @example URL for a specific user:
    #   repository.resource_url( "users", 1 ) # "/api/users/1"
    # @example URL with a specific action:
    #   repository.resource_url( "users", 1, null, "edit" ) # "/api/users/1/edit"
    # @example follows the recent_posts association (note: dependent on the implementation of gen_req_params):
    #   repository.resource_url( "users", 1, { recent_posts: true } ) # "/api/users/1?include=recent_posts"
    #
    resource_url: (collection_name, id, includes, action) ->        
        url = "/api/#{collection_name}/#{(id + '/') || ''}"
        url += "#{action}/" unless not action?
        
        if includes?
            query_params = @gen_req_params( includes )
            url = "#{url}?#{query_params}"

        url
    
    
    # Generates query params to follow the given associations on the server and include them in the
    # response.
    #
    # @param includes [Object] a tree representing the associations.
    # @return [String] the query param.
    #
    # @example
    #   repository.gen_req_params( blogs: { blog_posts: true } ) # "include=blogs,blogs.posts"
    #
    gen_req_params: (includes) ->
        params = null
        
        build_params = (includes, scope) ->
        
            for assoc_name, value of includes
                if params?
                    params += ","
                else
                    params = "include="
                
                if scope?
                    params += "#{scope}."

                params += assoc_name
                
                build_params( value, assoc_name )
        
        if includes?
            build_params( includes, null )
    
        params
    
    
    # Generates a GET request to read from the given collection.
    #
    # @param collection_name [String] the collection to read.
    # @option opts include [String] the associations to include in the response.
    # @option opts success [Function] the handler to call on a successful response.
    # @option opts error [Function] the handler to call in case of an error.
    # @option opts action [String] the action to append to the generated base URL.
    #        
    get_collection: (collection_name, opts) ->
        includes = opts?.include
        success = opts?.success
        error = opts?.error
        action = opts?.action
        
        if opts.url?
            url = opts.url
        else
            url = @resource_url( collection_name, null, includes, action )
        
        $.ajax
            type: 'GET',
            url: url,
            success: success,
            error: error,
            dataType: 'json'


    # Generates a GET request to read from the specified resource.
    #
    # @param collection_name [String] the collection the resource belongs to.
    # @param id [Number] the id of the resource to read.
    # @option opts include [String] the associations to include in the response.
    # @option opts success [Function] the handler to call on a successful response.
    # @option opts error [Function] the handler to call in case of an error.
    # @option opts action [String] the action to append to the generated base URL.
    #    
    get_resource: (collection_name, id, opts) ->
        includes = opts?.include
        success = opts?.success
        error = opts?.error
    
        url = @resource_url( collection_name, id, includes )
        $.ajax
            type: 'GET',
            url: url,
            success: success,
            error: error,
            dataType: 'json'
         
         
    # Generates a POST request to create a new instance of a resource.
    #
    # @param collection_name [String] the collection the resource belongs to.
    # @param data [Object] JSON representation of the resource.
    # @option opts success [Function] the handler to call on a successful response.
    # @option opts error [Function] the handler to call in case of an error.
    #    
    create_resource: (collection_name, data, opts) ->
    
        success = opts?.success
        error = opts?.error
        
        url = @resource_url( collection_name )
        
        $.ajax
            type: 'POST'
            url: url
            data: { data: data }
            success: success
            error: error
            dataType: 'json'
            

    # Generates a PUT request to update a specified resource.
    #
    # @param collection_name [String] the collection the resource belongs to.
    # @param id [Number] the id of the resource to read.
    # @param data [Object] JSON representation of the resource.
    # @option opts success [Function] the handler to call on a successful response.
    # @option opts error [Function] the handler to call in case of an error.
    #    
    update_resource: (collection_name, id, data, opts) ->
    
        success = opts?.success
        error = opts?.error
        
        url = @resource_url( collection_name, id )
        
        $.ajax
            type: 'PUT'
            url: url
            data: { data: data }
            success: success
            error: error
            dataType: 'json'
