namespace "core"

class core.Bootstrapper

    configure_container: ( application ) ->
        @application = application
        container = new core.Container()
        
        # TODO: do we need these?
        container.register_instance "Application", @application
        container.register_instance "Container", container
        
        container.register_class "Sandbox", core.Sandbox
        container.register_class "Mediator", core.Mediator, singleton: true
        container.register_class "Environment", core.types.Environment, singleton: true
        
        # TODO: yurk!  should resolve( @application ) instead, maybe?
        @application.mediator = container.resolve "Mediator"
        
        container
        
    configure_environment: ( env ) ->
        env.defineSimpleType "Inherit"
        env.defineSimpleType "Number"
        env.defineSimpleType "String"
    
    register_modules: (container) ->
        
        app_modules = @application.config "app.modules"
        app_modules ?= app?.modules
        
        module_regex = /(.*)Module/
        for klass_name, klass of app_modules when matches = module_regex.exec( klass_name )
            module_name = _.string.underscored( matches[0] )
            module = container.resolve( new klass( module_name ) )
            @application.register_module( module )
        
        app_controllers = @application.config "app.controllers"
        app_controllers ?= app?.controllers
        
        controller_regex = /(.*)Controller/
        for klass_name, klass of app_controllers when matches = controller_regex.exec( klass_name )
            controller_name = _.string.underscored( matches[0] )
            controller = container.resolve( new klass( controller_name ) )
            @application.register_controller( controller )
    
    register_helpers: (container) ->
    
        helper_regex = /(.*)Helper/
        for klass_name, klass of app?.helpers when matches = helper_regex.exec( klass_name )
            helper_name = _.string.underscored( matches[1] )
            helper = container.resolve( new klass() )
            @application.register_helper( helper_name, helper )
            
    register_models: ->
        core.Model.default_env = @application.env

        # TODO: DRY this up (see also ComplexType serialization)
        is_model = ( model_class ) ->
            model_class.prototype.constructor.__super__?.constructor == core.Model
            
        app_models = @application.config "app.models"
        app_models ?= app?.models
   
        for model_name, model_class of app_models when is_model( model_class )
            # model_name = _.string.underscored( model_name )
            @application.register_model( model_name, model_class )