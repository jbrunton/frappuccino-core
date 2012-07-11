describe "core.Sandbox", ->

    container = null

    class Renderer
    app = {}

    beforeEach ->
        container = ( new core.Container )
            .register_class( "Sandbox", core.Sandbox )
            .register_instance( "Application", app )
            .register_class( "Renderer", Renderer )

    describe "dependencies", ->
    
        mediator = {}
        
        beforeEach ->
            container.register_instance( "Mediator", mediator )
        
        it "should have an instance of the Application", ->
            sandbox = container.resolve "Sandbox"
            expect( sandbox.application ).toBe app
            
        it "should have an instance of a Mediator", ->
            sandbox = container.resolve "Sandbox"
            expect( sandbox.mediator ).toBe mediator
            
        it "should have a Renderer", ->
            sandbox = container.resolve "Sandbox"
            expect( sandbox.renderer instanceof Renderer ).toBeTruthy()
        
    describe "events", ->
        
        mediator = null
        sandbox = null
                    
        describe "the publish method", ->

            beforeEach ->
                mediator = jasmine.createSpyObj( "mediator", [ "publish" ] )
                container.register_instance( "Mediator", mediator )

            it "publishes events via the application Mediator", ->
                sandbox = container.resolve "Sandbox"
                sandbox.publish( "MyModule.event" )
                
                expect( mediator.publish ).toHaveBeenCalledWith( "MyModule.event" )
                
            it "publishes events with arguments", ->
                sandbox = container.resolve "Sandbox"
                sandbox.publish( "MyModule.event", 1, 2, 3 )
                
                expect( mediator.publish ).toHaveBeenCalledWith( "MyModule.event", 1, 2, 3 )
    
            it "implicitly scopes published events according to the name of the sandbox module", ->
                my_module = name: "MyModule"
                sandbox = container.resolve "Sandbox", my_module
                sandbox.publish( "event" )
                
                expect( mediator.publish ).toHaveBeenCalledWith( "MyModule.event" )
    
            it "errors if asked to publish an invalid event name", ->
                sandbox = container.resolve "Sandbox"
                expect(-> sandbox.publish( "not.an.event" )).toThrow()
        
        describe "the bind_subscriptions method", ->
            
            it "binds event handlers on a target object", ->
                mediator = jasmine.createSpyObj( "mediator", [ "subscribe" ] )
                container.register_instance( "Mediator", mediator )
                
                event_name = "MyModule.event"
                handler = ->
                target = "@MyModule.event": handler
                
                sandbox = container.resolve "Sandbox"
                sandbox.bind_subscriptions target
                
                expect( mediator.subscribe ).toHaveBeenCalledWith( event_name, handler, target )
