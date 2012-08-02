describe "core.extend", ->

    class TestModule
        foo: "foo"

    class TestClass
        core.extend(@, TestModule)

    it "should extend the class with static methods", ->
        expect(TestClass.foo).toBe "foo"