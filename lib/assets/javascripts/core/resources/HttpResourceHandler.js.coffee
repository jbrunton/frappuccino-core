namespace "core.resources", ->

    class @HttpResourceHandler
    
        resource_url: (collection_name, id, includes, action) ->        
            base_url = "/api/#{collection_name}/#{id or= ''}"
            base_url += "#{action}/" unless !action?
            query_params = @gen_req_params( includes )
            
            if query_params
                "#{base_url}?#{query_params}"
            else
                base_url
        
        gen_req_params: (includes) ->
            params = null
            
            build_params = (includes, scope) ->
            
                for assoc_name, value of includes
                    if params?
                        params += ","
                    else
                        params = "includes="
                    
                    if scope?
                        params += "#{scope}."
    
                    params += assoc_name
                    
                    build_params( value, assoc_name )
            
            if includes?
                build_params( includes, null )
        
            params
            
        get_collection: (collection_name, opts) ->
            includes = opts?.includes
            success = opts?.success
            error = opts?.error
            action = opts?.action
            
            url = @resource_url( collection_name, null, includes, action )
            
            $.ajax
                type: 'GET',
                url: url,
                success: success,
                error: error,
                dataType: 'json'
    
        get_resource: (collection_name, id, opts) ->
            includes = opts?.includes
            success = opts?.success
            error = opts?.error
        
            url = @resource_url( collection_name, id, includes )
            $.ajax
                type: 'GET',
                url: url,
                success: success,
                error: error,
                dataType: 'json'
                
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
