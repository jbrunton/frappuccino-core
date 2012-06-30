describe "core.ApplicationModule", ->

    container = null

    beforeEach ->
        container = new core.Container
        container.register_instance "Mediator", new core.Mediator
        container.register_class "ApplicationModule", core.ApplicationModule
        container.register_class "Sandbox", core.Sandbox
        container.register_class "Renderer", {}
        container.register_class "Environment", {}
        container.register_class "Router", {}
        
    it "should have a sandbox", ->
        app_module = container.resolve "ApplicationModule"
        
        expect(app_module.sandbox).toBeDefined()
        expect(app_module.sandbox instanceof core.Sandbox).toBeTruthy()
        expect(app_module.sandbox.module).toBe app_module
        
    it "should create a child container with its own sandbox instance registered", ->
        app_module = container.resolve "ApplicationModule"
        
        expect(app_module.container).toBeDefined()
        expect(app_module.container.resolve "Sandbox").toBe app_module.sandbox
        expect(container.resolve "Sandbox").not.toBe app_module.sandbox