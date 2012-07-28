describe "core.types.ListType", ->

    env = null
    FooTy = null
    
    beforeEach ->
        env = new core.types.Environment
        env.propertyFactory = new core.types.SimplePropertyFactory

        env.defineSimpleType "number"

        FooTy = env.defineComplexType "Foo",
            attr:
                foos: "List[number]"

    it "serializes lists", ->
        obj =
            foos: -> [1, 2, 3]
        
        data = FooTy.serialize obj, env,
            foos: true
        
        expect(data.foos).toEqual [1, 2, 3]
        
    it "deserializes lists", ->
        data =
            foos: [1, 2, 3]
        
        obj = FooTy.deserialize data, env
        
        expect(obj.foos()).toEqual [1, 2, 3]