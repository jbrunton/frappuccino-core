namespace "core", ->

        class @Bootstrapper
        
            constructor: (@application) ->
    
            configure_container: ->
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
            
            register_modules: (container) ->
                
                module_regex = /.*Module/
                for name, klass of app?.modules when module_regex.test( name )
                    module = container.resolve( new klass( name ) )
                    @application.register_module( module )
                
                controller_regex = /(.*)Controller/
                for klass_name, klass of app?.controllers when matches = controller_regex.exec( klass_name )
                    controller_name = _.string.underscored( matches[1] )
                    controller = container.resolve( new klass( controller_name ) )
                    @application.register_controller( controller )
            
            register_helpers: (container) ->
            
                helper_regex = /(.*)Helper/
                for klass_name, klass of app?.helpers when matches = helper_regex.exec( klass_name )
                    helper_name = _.string.underscored( matches[1] )
                    helper = container.resolve( new klass() )
                    @application.register_helper( helper_name, helper )
                    
            register_models: ->
            
                is_model = ( model_class ) ->
                    model_class.prototype.constructor.__super__?.constructor == core.Model
           
                for model_name, model_class of app?.models when is_model( model_class )
                    model_name = _.string.underscored( model_name )
                    @application.register_model( model_name, model_class )