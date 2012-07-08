describe "core.resources.Resource", ->

    env = null
    fooTy = null
    
    beforeEach ->
        env = new core.types.Environment
        env.propertyFactory = new core.types.SimplePropertyFactory
        
        env.defineSimpleType "string"
        
        fooTy = env.defineResource "foo", "foos"
            attr:
                foo: "string"
            attr_accessible: [ "foo" ]
    
    it "defines a resource", ->
        foo = env.create "foo"
        
        expect(foo.save).toBeDefined()
        expect(foo.load).toBeDefined()