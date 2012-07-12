namespace "core", ->
 
 class @Application extends core.Mixable
    @include core.DependentMixin
    
    @dependency renderer: "Renderer"
    @dependency router: "Router"
    @dependency mediator: "Mediator"
    @dependency env: "Environment"
    
    helpers: {}
    modules: {}
        
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
        model_class::collection_name = "#{model_name}s"
        @env.register_model model_class
        
    bind_helper: ( helper_name, target ) ->
        helper = @helpers[helper_name]
        if helper?
            _.extend( target, helper )
            
    bind_events: (obj) ->
        regex = /^@((\w+)\.)?(\w+)$/

        for eventName, handler of obj when eventName[0] == "@"
            @mediator.subscribe eventName[1..], handler, obj

    run: (bootstrapper_class) ->
        bootstrapper = new bootstrapper_class( @ )

        container = bootstrapper.configure_container()
        container.resolve( @ )

        bootstrapper.register_modules( container )   
        bootstrapper.register_helpers( container )
        bootstrapper.register_models()
        
        @mediator.publish "Application.initialize"
        @mediator.publish "Application.ready"
        
        bootstrapper
        