describe "core.BaseObject", ->

    class Foo
        @foo: "foo"
        bar: "bar"
        
    class Bar extends core.BaseObject
        @include Foo

    describe "the @include method", ->
            
        it "should mixin static fields", ->
            expect(Bar.foo).toBe "foo"
            
        it "should mixin instance fields", ->
            bar = new Bar
            expect(bar.bar).toBe "bar"

    describe "inheritance", ->
    
        class Baz extends Bar
    
        it "transmits mixin fields correctly to subclasses", ->
            baz = new Baz
            expect(baz.bar).toBe "bar"