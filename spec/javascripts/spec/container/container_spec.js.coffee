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
        
        fred = container.resolve "Person", ["Fred"]
        expect( fred instanceof Person ).toBeTruthy()
        expect( fred.name ).toEqual( "Fred" )
        
    it "resolves classes registered as singletons to the same instance", ->
        container.register_class "POTUS", Person, singleton: true
        
        obama = container.resolve "POTUS", ["Barack Obama"]
        expect( container.resolve "POTUS" ).toBe( obama )
        
    it "resolves nested dependencies", ->
        class PersonWithHat extends Person
            constructor: ( name ) -> super( name )
            @dependency hat: "Hat", "trilby", "black"
            
        class Hat
            constructor: ( @type, @color ) ->

        container.register_class "Hat", Hat
        container.register_class "PersonWithHat", PersonWithHat
        
        hat = container.resolve "Hat", ["trilby", "black"]
        
        fred = container.resolve "PersonWithHat", ["Fred"]
        
        expect( fred instanceof PersonWithHat ).toBeTruthy()
        expect( fred.hat instanceof Hat ).toBeTruthy()
        expect( fred.hat.type ).toEqual( "trilby" )
        expect( fred.hat.color ).toEqual( "black" )

    it "should resolve dependencies defined by deferred functions", ->
        class Passport
            constructor: ( @belongs_to ) ->
            
        class PersonWithPassport extends Person
            constructor: ( name ) -> super( name )
            @dependency passport: ( container ) ->
                container.resolve "Passport", [@]
            
        container.register_class "PersonWithPassport", PersonWithPassport
        container.register_class "Passport", Passport
        
        fred = container.resolve "PersonWithPassport", ["Fred"]

        expect( fred.passport instanceof Passport ).toBeTruthy()
        expect( fred.passport.belongs_to ).toBe fred
        
    it "should resolve dependencies defined by factory methods", ->
        propertyFactoryFunction = ( initVal ) ->
            val = initVal
            ->  if arguments.length == 0
                    val
                else
                    val = arguments[0]
                    @

        container.register_factory "Property", propertyFactoryFunction
        
        class PersonWithBag extends Person
            @dependency bag: "Property", "Gucci"
            
        container.register_class "PersonWithBag", PersonWithBag
            
        #fred = container.resolve "PersonWithBag", "Fred"
        #expect( fred.name() ).toEqual( "Fred" )
        
        #fred.name( "Freddy" )
        #expect( fred.name() ).toEqual( "Freddy" )
