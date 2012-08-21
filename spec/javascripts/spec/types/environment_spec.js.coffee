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
        
            env.defineComplexType "foo",
                attributes:
                    baz:
                        class_name: 'string'
                        accessible: true
            
            env.defineComplexType "bar",
                attributes:
                    bar:
                        class_name: 'string'
                        accessible: true
                    foo:
                        class_name: 'foo'
                
        describe "serialize", ->
        
            it "serializes arbitrary types", ->
                data = env.serialize "bar",
                    bar: -> "bar"
                    foo: ->
                        baz: -> "baz"
                        
                expect(data.bar).toBe "bar"
                expect(data.foo).toBeUndefined()
        
        describe "deserialize", ->
        
            it "deserializes arbitrary types", ->
                obj = env.deserialize "bar",
                    bar: "bar"
                    foo:
                        baz: "baz"
                
                expect(obj.bar()).toBe "bar"
                expect(obj.foo().baz()).toBe "baz"