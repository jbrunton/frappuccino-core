describe "core.include", ->
        
    class TestModule
        @foo: "foo"
        bar: "bar"

    class TestClass
        core.include(@, TestModule)

    it "should mix in static fields", ->
        expect(TestClass.foo).toBe "foo"
        
    it "should mix in instance fields", ->
        instance = new TestClass
        expect(instance.bar).toBe "bar"
