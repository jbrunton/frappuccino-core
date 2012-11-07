namespace "core"
 
class core.Application extends core.DependentObject
    @dependency renderer: "Renderer"
    @dependency router: "Router"
    @dependency mediator: "Mediator"
    @dependency env: "Environment"
    
    helpers: {}
    modules: {}
    
    resolve_module: ( module_name ) ->
        @modules[ module_name ]
        
    resolve_helper: ( helper_name ) ->
        @helpers[ helper_name ]
    
    running: false
    
    constructor: ->
        @configure()
        
    _config: {}
        
    config: ( key, value ) ->
        if value?
            @_config[key] = value
        else
            @_config[key]
        
    configure: ->
        @config "app.models", app?.models
        
    register_route: ( url, route_name, controller ) ->
        @router.route url, name, ->
            app.request =
                active_controller: controller
            
            controller[route_name].apply(controller, arguments)
        
    register_module: (module) ->
        @modules[module.name] = module
        module.sandbox.bind_subscriptions module
        
    register_controller: (controller) ->
        @register_module controller
        
        for url, route_name of controller.routes
            @register_route url, route_name, controller
            
        for name, content of controller.templates
            @renderer.register_template name, content
            
    register_helper: ( name, helper ) ->
        # TODO: would be better to lookup a sandbox here - but need to be able to have distinct,
        # shared helpers first (where currently they all get included in the "application" helper)
        @bind_events helper

        @helpers[name] = helper
        
    register_model: ( model_name, model_class ) ->
        model_class::class_name = model_name
        model_class::collection_name = core.support.inflector.tableize( model_name )
        @env.register_model model_class
        
    bind_helper: ( helper_name, target ) ->
        helper = @helpers[helper_name]
        if helper?
            _.extend( target, helper )
            
    bind_events: (obj) ->
        regex = /^@((\w+)\.)?(\w+)$/

        for eventName, handler of obj when eventName[0] == "@"
            @mediator.subscribe eventName[1..], handler, obj

    run: (bootstrapper) ->
        container = bootstrapper.configure_container( @ )
        container.resolve( @ )

        bootstrapper.configure_environment( @env )

        # TODO: should these be in the Application class, not the Bootstrapper?  certainly, this
        # needs tidying...
        bootstrapper.register_modules( container )   
        bootstrapper.register_helpers( container )
        bootstrapper.register_models()
        
        @mediator.publish "Application.initialize"
        @mediator.publish "Application.ready"
        
        @running = true
        
        bootstrapper
        