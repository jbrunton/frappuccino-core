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
        
    describe "has a publish method", ->
        
        mediator = null
        
        beforeEach ->
            mediator = publish: ->    
            container.register_instance( "Mediator", mediator )
            spyOn( mediator, "publish" )

        it "publishes events", ->
            sandbox = container.resolve "Sandbox"
            sandbox.publish( "anEvent", "some_argument" )
            
            expect( mediator.publish ).toHaveBeenCalledWith( "anEvent", "some_argument" )        
