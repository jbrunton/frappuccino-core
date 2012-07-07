describe "core.Sandbox", ->

    container = null

    beforeEach ->
        container = new core.Container
        container.register_instance "Mediator", new core.Mediator
        container.register_class "ApplicationModule", core.ApplicationModule
        container.register_class "Sandbox", core.Sandbox
        container.register_instance "Application", new core.Application
        container.register_class "Renderer", {}
        container.register_class "Environment", {}
        container.register_class "Router", {}
        
    it "should resolve modules", ->
        test_module = container.resolve "ApplicationModule", "test_module"
        app = container.resolve "Application"
        app.register_module test_module

        sandbox = container.resolve "Sandbox"
        
        expect(sandbox.resolve_module "test_module").toBe test_module
        
