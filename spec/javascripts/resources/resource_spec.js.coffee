describe "core.resources.Resource", ->

    env = null
    fooTy = null
    
    beforeEach ->
        env = new core.types.Environment
        env.defineSimpleType "string"
        fooTy = env.defineResource "Foo",
            foo: "string"
    
    it "defines a resource", ->
        foo = env.create "Foo"
        
        expect(foo.save).toBeDefined()
        expect(foo.load).toBeDefined()