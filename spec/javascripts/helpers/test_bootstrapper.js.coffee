namespace "test_helper", ->

    @Bootstrapper = ->
    
        class extends core.Bootstrapper
        
            # TODO: remove app param, and register Renderer as a singleton type
            configure_container: ->
                container = super()
                
                # container.registerClass "Application", app.Application, singleton: true
                container.register_class "Renderer", {}, singleton: true
                container.register_class "Router", {}, singleton: true
                container.register_class "PropertyFactory", core.types.SimplePropertyFactory, singleton: true
                container.register_class "ModelRepository", core.resources.LocalResourceHandler, singleton: true
    
                # TODO: move this to a resources controller which reads from the api feed
                env = container.resolve "Environment"
                
                env.defineSimpleType "number"
                env.defineSimpleType "string"
                                                
                container
