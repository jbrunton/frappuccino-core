#= require helpers/test_bootstrapper

feature "Dependency Injection", ->

    summary(
        'As a client of the framework',
        'I want to specify dependencies to be resolved at runtime'
    )

    class Hat
        constructor: ( @type = "trilby", @color = "black" ) ->

    class Person extends core.DependentObject
        @dependency hat: "Hat"
        constructor: ( @name ) ->
        
        
    create_container = ( mappings ) ->
        container = new core.Container
        for name, klass of mappings
            container.register_class name, klass
        container
        
        
    scenario "Resolve dependency properties", ->
    
        container = fred = null
    
        Given "I have a container with a class mapping registered", ->
            container = create_container "Hat": Hat, "Person": Person
    
        When "I resolve a new instance of the mapping with the container", ->
            fred = container.resolve "Person", ["Fred"]
    
        Then "the container should resolve an instance of the class", ->
            expect( fred instanceof Person ).toBeTruthy()
            
        And "any dependency properties should be resolved", ->
            expect( fred.hat instanceof Hat ).toBeTruthy()
            
    scenario "Provide arguments to dependency properties", ->
    
        container = queen = null
        
        class Queen extends core.DependentObject
            @dependency crown: "Hat", "crown", "gold"
        
        Given "I have a container with a singleton class mapping", ->
            container = create_container "Hat": Hat, "Queen": Queen
            
        When "I resolve an instance of the mapping", ->
            queen = container.resolve "Queen", ["Elizabeth"]
            
        Then "any dependency properties should be resolved", ->
            expect( queen.crown instanceof Hat ).toBeTruthy()
            
        And "resolved dependencies should be passed the given arguments when resolved", ->
            expect( queen.crown.type ).toBe( "crown" )
            expect( queen.crown.color ).toBe( "gold" )
            
    
    scenario "Provide constructor to dependency properties", ->
    
        container = queen = null
        
        class Queen extends core.DependentObject
            @dependency heir: (container) ->
                container.resolve "Person", ["William"]
        
        Given "I have a container", ->
            container = create_container "Hat": Hat, "Queen": Queen, "Person": Person
            
        When "I resolve the mapping", ->
            queen = container.resolve "Queen", ["Elizabeth"]
            
        Then "any dependency properties specified by a constructor function should be resolved", ->
            expect( queen.heir instanceof Person ).toBeTruthy()
            expect( queen.heir.name ).toBe( "William" )           
