namespace "core", ->
 
 class @Application extends core.Mixable
    @include core.DependentMixin
    
    @dependency renderer: "Renderer"
    @dependency router: "Router"
    
    helpers: {}
        
    register_route: ( url, route_name, controller ) ->
        @router.route url, name, ->
            app.request =
                active_controller: controller
            
            controller[route_name].apply(controller, arguments)
        
    register_module: (module) ->
        module.sandbox.bind module
        
    register_controller: (controller) ->
        @register_module controller
        
        for url, route_name of controller.routes
            @register_route url, route_name, controller
            
        for name, content of controller.templates
            @renderer.register_template name, content
            
    register_helper: ( name, helper ) ->
        @helpers[name] = helper
        
    bind_helper: ( helper_name, target ) ->
        helper = @helpers[helper_name]
        if helper?
            _.extend( target, helper )
                
    run: (bootstrapper_class) ->
        bootstrapper = new bootstrapper_class( @ )

        container = bootstrapper.configure_container()
        container.resolve( @ )

        bootstrapper.register_modules( container )   
        bootstrapper.register_helpers( container )
        
        @mediator.publish "Application.initialize"
        @mediator.publish "Application.ready"
        
        bootstrapper
        