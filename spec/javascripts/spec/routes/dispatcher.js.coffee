describe "core.routes.Dispatcher", ->

    describe "#dispatch", ->
        
        it "invokes the specified action on the specified controller", ->
            app = modules:
                users_controller: { view: -> }
            
            spyOn(app.modules.users_controller, 'view')        
            
            dispatcher = new core.routes.Dispatcher( app, 'users', 'view' )
            dispatcher.dispatch()
            expect( app.modules.users_controller.view).toHaveBeenCalled()
            
            