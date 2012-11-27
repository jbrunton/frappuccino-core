namespace "core.routes"

###
class core.routes.Scope

    constructor: ->
        @stack = []
        
    push: ( path ) ->
        @stack.push path
        
    pop: ->
        @stack.pop()
    
    scoped_url: ( url ) ->
        "/#{@stack.join '/'}/url"
        
    scoped_namespace: ( namespace ) ->
        "/"
###    
    
class core.routes.Mapper extends core.DependentObject

    @dependency router: "Router"

    constructor: ( @app ) ->

    draw: ( block )->
        block.apply(@)        
        
    match: ( url, opts ) ->
        { controller, action } = opts
        @router.route url, controller, action
        
    resource: ( resource ) ->
        for action in ['view', 'edit']
            path_name = opt?.paths_names?[action]?
            path_name ?= action
            @router.route "#{resource}/:id/#{action}", resource, action
        for action in ['create']
            path_name = opt?.paths_names?[action]?
            path_name ?= action
            @router.route "#{resource}/#{action}", resource, action
        
    #namespace: ( path, block ) ->
    #    @scope.push path
    #    @draw( block )
        