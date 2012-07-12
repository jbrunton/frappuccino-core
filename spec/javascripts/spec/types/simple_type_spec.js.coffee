describe "core.types.SimpleType", ->

    ty = null

    beforeEach ->
        ty = new core.types.SimpleType "MyType"

    it "should have a 'tyName' property", ->
        expect(ty.tyName).toBe("MyType")
        
    it "should provide the identity for serializing and deserializing by default", ->
        expect(ty.serialize 1).toBe(1)
        expect(ty.deserialize 1).toBe(1)
        
    it "may be constructed with custom serialize and deserialize functions", ->
        ty = new core.types.SimpleType "MyType", ((x) -> x + 1), ((x) -> x - 1)
        
        expect(ty.serialize 1).toBe(2)
        expect(ty.deserialize 2).toBe(1)