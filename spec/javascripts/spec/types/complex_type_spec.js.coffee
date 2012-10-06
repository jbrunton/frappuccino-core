describe "core.types.ComplexType", ->

    fooTy   = null
    barTy   = null
    env     = null

    beforeEach ->
        env = new core.types.Environment
        env.propertyFactory = new core.types.SimplePropertyFactory
        
        env.defineSimpleType "string"
        
        fooTy = env.defineComplexType "foo",
            attributes:
                baz:
                    class_name: 'string'
                    serialize: true
            
        barTy = env.defineComplexType "bar",
            attributes:
                bar:
                    class_name: 'string'
                    serialize: true
                foo:
                    class_name: 'foo'

    it "should have a 'class_name' property", ->
        expect(fooTy.tyName).toBe "foo"

    describe "serialize", ->
    
        obj = null
    
        beforeEach ->
            obj =
                bar: -> "bar"
                foo: ->
                    baz: -> "baz"     


        it "should serialize records", ->                    
            data = barTy.serialize obj, env
            
            expect(data.bar).toBe "bar"
            expect(data.foo).toBeUndefined()
            
        it "should serialize complex types referenced in 'includeSpecs'", ->
            data = barTy.serialize obj, env,
                foo:
                    baz: true
                
            expect(data.bar).toBeUndefined()
            expect(data.foo.baz).toBe "baz"
            
    describe "deserialize", ->
    
        data = null
        
        beforeEach ->
            data =
                bar: "bar"
                foo:
                    baz: "baz"
                    
        it "should deserialize complex records", ->
            obj = barTy.deserialize data, env
            
            expect(obj.bar()).toBe "bar"
            expect(obj.foo().baz()).toBe "baz"