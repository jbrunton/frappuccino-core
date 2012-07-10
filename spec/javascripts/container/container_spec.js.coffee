describe "core.Container", ->

    container = null

    beforeEach ->
        container = new core.Container
    
    it "resolves registered instances", ->
        my_object = new Object
        container.register_instance "object", my_object
        
        expect( container.resolve "object" ).toBe my_object
        
    it "resolves registered classes", ->
        class MyClass
        container.register_class "MyClass", MyClass
        
        expect( container.resolve( "MyClass" ) instanceof MyClass ).toBeTruthy()
        
    it "resolves classes registered as singletons to the same instance", ->
        class MyClass
        container.register_class "MyClass", MyClass, singleton: true
        
        expect( container.resolve "MyClass" ).toBe( container.resolve "MyClass" )        
        
    it "resolves nested dependencies", ->
        class MyClass extends core.Mixable
            @include core.DependentMixin
            @dependency object: "object"
            
        my_object = new Object

        container.register_instance "object", my_object
        container.register_class "MyClass", MyClass
        
        my_instance = container.resolve "MyClass"
        
        expect( my_instance instanceof MyClass ).toBeTruthy()
        expect( my_instance.object ).toBe my_object

    it "should resolve dependencies defined by deferred functions", ->
        class MyClass extends core.Mixable
            @include core.DependentMixin
            @dependency object: -> my_object
            
        my_object = new Object
        
        container.register_instance "object", my_object
        container.register_class "MyClass", MyClass
        
        my_instance = container.resolve "MyClass"
        
        expect( my_instance.object ).toBe my_object
