describe "core.Container", ->

    container   = null

    class Foo
        constructor: ->
    
    class Bar extends core.Mixable
            @include core.DependentMixin
    
            constructor: ->
        
            @dependency foo: "foo"
            @dependency bar: -> ["foo"]
        
    beforeEach ->
        container = new core.Container
    
    it "should resolve registered instances", ->
        foo = new Foo
        container.register_instance "foo", foo
        
        expect(container.resolve "foo").toBe foo
        
    it "should resolve registered types", ->
        container.register_class "Foo", Foo
        
        expect(container.resolve_class "Foo").toBe Foo
        expect(container.resolve("Foo") instanceof Foo).toBeTruthy()
        
    it "should resolve dependencies defined by type", ->
        foo = new Object
        
        container.register_instance "foo", foo
        container.register_class "Bar", Bar
        
        bar = container.resolve "Bar"
        
        expect(bar.foo).toBe foo
        
    it "should resolve dependencies defined by deferred functions", ->
        foo = new Object
        
        container.register_instance "foo", foo
        container.register_class "Bar", Bar
        
        bar = container.resolve "Bar"
        
        expect(bar.foo).toBe foo
