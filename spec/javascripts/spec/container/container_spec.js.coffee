describe "core.Container", ->

    container = null
    
    class Person extends core.DependentObject
        constructor: ( @name ) ->

    beforeEach ->
        container = new core.Container
    
    it "resolves registered instances", ->
        fred = { name: "Fred" }
        container.register_instance "fred", fred
        
        expect( container.resolve "fred" ).toBe fred
        
    it "resolves registered classes", ->
        container.register_class "Person", Person
        
        fred = container.resolve( "Person", "Fred" )
        expect( fred instanceof Person ).toBeTruthy()
        expect( fred.name ).toEqual( "Fred" )
        
    it "resolves classes registered as singletons to the same instance", ->
        container.register_class "POTUS", Person, singleton: true
        
        expect( container.resolve "POTUS" ).toBe( container.resolve "POTUS" )        
        
    it "resolves nested dependencies", ->
        class PersonWithHat extends Person
            constructor: ( name ) -> super( name )
            @dependency hat: "Hat"
            
        trilby = { type: "trilby" }

        container.register_instance "Hat", trilby
        container.register_class "PersonWithHat", PersonWithHat
        
        fred = container.resolve "PersonWithHat", "Fred"
        
        expect( fred instanceof PersonWithHat ).toBeTruthy()
        expect( fred.hat ).toBe trilby

    it "should resolve dependencies defined by deferred functions", ->
        class Passport
            constructor: ( @belongs_to ) ->
            
        class PersonWithPassport extends Person
            constructor: ( name ) -> super( name )
            @dependency passport: ( container ) ->
                container.resolve( "Passport", @ )
            
        container.register_class "PersonWithPassport", PersonWithPassport
        container.register_class "Passport", Passport
        
        fred = container.resolve( "PersonWithPassport", "Fred" )

        expect( fred.passport instanceof Passport ).toBeTruthy()
        expect( fred.passport.belongs_to ).toBe fred
