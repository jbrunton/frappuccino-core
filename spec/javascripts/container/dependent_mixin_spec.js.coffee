describe "core.DependentMixin", ->

    class Foo extends core.Mixable    
        @include core.DependentMixin
        
        @dependency foo: "type_of_foo"

    it "should define dependencies", ->
        expect(Foo::._dependencies).toEqual foo: ["type_of_foo", undefined]