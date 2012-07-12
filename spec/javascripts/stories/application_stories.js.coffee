#= require helpers/test_bootstrapper

feature "Application Bootstrapper", ->
        
    summary(
        'As a client of the framework',
        'I want to bootstrap and run my application'
    )

    scenario "Run an application with a bootstrapper", ->
    
        app = null

        Given "I have an application", ->
            app = new core.Application
    
        When "I run the application with a bootstrapper", ->
            app.run( test_helper.Bootstrapper() )
    
        Then "the application should be running", ->
            (expect app.running).toBe true
            
        # TODO: test for Application.initialize and Application.ready events
        
    scenario "core.Bootstrapper initializes the environment with the application models", ->
    
        app = MyModel = null
        
        Given "I have an application", ->
            app = new core.Application
        
        When "I configure and run the application", ->
            MyModel = class extends core.Model
            app.config "app.models",
                MyModel: MyModel
            app.run( test_helper.Bootstrapper() )
            
        Then "the application environment should be configured with the application models", ->
            my_model = app.env.create( "my_model" )
            expect( my_model instanceof MyModel ).toBe true
            
    scenario "core.Bootstrapper initializes the application modules", ->

        app = MyModule = null
        
        Given "I have an application", ->
            app = new core.Application
        
        When "I configure and run the application", ->
            MyModule = class extends core.ApplicationModule
                publish_event: -> @sandbox.publish "event"
                @on "event", -> @event_handler()                    
                event_handler: ->            
            
            app.config "app.modules",
                MyModule: MyModule
            app.run( test_helper.Bootstrapper() )
            
        Then "the application should instantiate the application modules", ->
            my_module = app.resolve_module( "MyModule" )
            expect( my_module instanceof MyModule ).toBe true
        
        And "the module event handlers should have been bound", ->
            my_module = app.resolve_module( "MyModule" )
            spyOn( my_module, 'event_handler' )
            my_module.publish_event()
            expect( my_module.event_handler ).toHaveBeenCalled()