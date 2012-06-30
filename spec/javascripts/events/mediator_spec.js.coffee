describe "core.Mediator", ->

    mediator = null

    beforeEach ->
        mediator = new core.Mediator
        
    it "has a publish method", ->
        expect(mediator.publish).toBeDefined()
        
    it "has a subscribe method", ->
        expect(mediator.subscribe).toBeDefined()
    
    describe "the publish method", ->
    
        it "invokes subscribed handlers for the event", ->
            target = { foo: -> }

            spyOn target, "foo"
            
            mediator.subscribe "foo", target.foo
            expect(target.foo).not.toHaveBeenCalled()
            
            mediator.publish "foo"
            expect(target.foo).toHaveBeenCalled()