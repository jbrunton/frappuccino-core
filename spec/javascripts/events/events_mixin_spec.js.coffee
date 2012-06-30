describe "core.EventsObject", ->

    class Foo extends core.Mixable
        @include core.EventsMixin
        
        @on "Bar", ->
        
    foo = new Foo
        
    it "mixes in a publish method", ->
        expect(foo.publish).toBeDefined()

    describe "the @on method", ->
    
        it "should define a handler on the instance", ->
            expect(foo["@Bar"]).toBeDefined()