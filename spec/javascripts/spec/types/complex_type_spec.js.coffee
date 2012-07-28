describe "core.types.ComplexType", ->

    fooTy   = null
    barTy   = null
    env     = null

    beforeEach ->
        env = new core.types.Environment
        env.propertyFactory = new core.types.SimplePropertyFactory
        
        env.defineSimpleType "string"
        
        fooTy = env.defineComplexType "foo",
            attr:
                baz: 'string'
            attr_accessible: [ "baz" ]
            
        barTy = env.defineComplexType "bar",
            attr:
                bar: 'string'
                foo: 'foo'
            attr_accessible: [ "bar" ]

    it "should have a 'tyName' property", ->
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
                foo: true
                
            expect(data.bar).toBe "bar"
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