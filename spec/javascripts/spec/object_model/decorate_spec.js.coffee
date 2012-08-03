describe "core.decorate", ->

    class TestDecorator
        foo: "foo"
        constructor: -> @bar = "bar"

    target = new Object
    core.decorate( target, TestDecorator )
    
    it "should extend an object with instance fields", ->
        expect(target.foo).toBe "foo"
        
    it "should invoke the contstructor", ->
        expect(target.bar).toBe "bar"