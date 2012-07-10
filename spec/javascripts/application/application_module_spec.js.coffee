describe "core.ApplicationModule", ->

    # mock dependencies for the ApplicationModule
    class Sandbox
    class Environment
    class Renderer
    class Router

    # initialize a container
    container = ( new core.Container )
        .register_class( "ApplicationModule", core.ApplicationModule )
        .register_class( "Sandbox", Sandbox )
        .register_class( "Environment", Environment )
        .register_class( "Renderer", Renderer )
        .register_class( "Router", Router )


    beforeEach ->
    
    it "should have a name", ->
        app_module = container.resolve "ApplicationModule", "my_module"
        expect( app_module.name ).toBe "my_module"
        
    it "should have a Sandbox", ->
        app_module = container.resolve "ApplicationModule"        
        expect( app_module.sandbox instanceof Sandbox ).toBeTruthy()

    it "should have an Environment", ->
        app_module = container.resolve "ApplicationModule"        
        expect( app_module.env instanceof Environment ).toBeTruthy()
        
    it "should have a Renderer", ->
        app_module = container.resolve "ApplicationModule"
        expect( app_module.renderer instanceof Renderer ).toBeTruthy()
        
    it "should have a Router", ->
        app_module = container.resolve "ApplicationModule"        
        expect( app_module.router instanceof Router ).toBeTruthy()
        
    it "should create a child container with its own sandbox instance registered", ->
        app_module = container.resolve "ApplicationModule"
        
        expect(app_module.container instanceof core.Container).toBeTruthy()
        expect(app_module.container.resolve "Sandbox").toBe app_module.sandbox
        expect(container.resolve "Sandbox").not.toBe app_module.sandbox