describe "core.EventsModule", ->

    class Foo extends core.BaseObject
        @include core.EventsModule
        
        @on "Bar", ->
        
    foo = new Foo
        
    it "mixes in a publish method", ->
        expect(foo.publish).toBeDefined()

    describe "the @on method", ->
    
        it "should define a handler on the instance", ->
            expect(foo["@Bar"]).toBeDefined()