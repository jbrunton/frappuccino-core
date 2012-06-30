describe "core.types.Environment", ->

    env = null

    beforeEach ->
        env = new core.types.Environment
        env.propertyFactory = new core.types.SimplePropertyFactory

    it "allows you to define SimpleTypes", ->
        ty = env.defineSimpleType "MyType"
        
        expect(ty).toBeDefined()
        expect(ty.kind).toEqual("simple")
        
    it "allows you to define ComplexTypes", ->
        ty = env.defineComplexType "MyType"
        
        expect(ty).toBeDefined()
        expect(ty.kind).toEqual("complex")
        
    describe "getType", ->
    
        ty = null
    
        beforeEach ->
            ty = env.defineSimpleType "MyType"
    
        it "returns the type specified by 'tyName'", ->
            expect(env.getType "MyType").toEqual(ty)
    
        it "throws if the type is not defined", ->
            expect(-> env.getType "NotAType").toThrow("Type NotAType does not exist in environment")
            
    describe "serialization", ->
    
        beforeEach ->
            env.defineSimpleType "string"
        
            env.defineComplexType "FooTy",
                baz: 'string'
            
            env.defineComplexType "BarTy",
                bar: 'string'
                foo: 'FooTy'
                
        describe "serialize", ->
        
            it "serializes arbitrary types", ->
                data = env.serialize "BarTy",
                    bar: -> "bar"
                    foo: ->
                        baz: -> "baz"
                        
                expect(data.bar).toBe "bar"
                expect(data.foo).toBeUndefined()
        
        describe "deserialize", ->
        
            it "deserializes arbitrary types", ->
                obj = env.deserialize "BarTy",
                    bar: "bar"
                    foo:
                        baz: "baz"
                
                expect(obj.bar()).toBe "bar"
                expect(obj.foo().baz()).toBe "baz"