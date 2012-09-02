#= require helpers/test_bootstrapper


# Dependency Injection
# --------------------

feature "Dependency Injection", ->


    # Dependency injection (DI) allows class implementations to be be decoupled from their
    # dependencies, which greatly facilitates testing and the sharing of code across different
    # platforms and environments - as the DI container can be configured differently with
    # appropriate concrete implementations of each class in each different use case.
        
    summary(
        'As a client of the framework',
        'I want to specify dependencies to be resolved at runtime'
    )


    # The DI container is typically used to resolve dependencies specified on classes which inherit
    # from `core.DependentObject`, which implements the static method `dependency`.

    class Sedan extends core.DependentObject
        @dependency repository: "HttpRepository"
        @dependency driver: "Driver"


    # The concrete classes used for this test suite.

    class HttpRepository
    class Driver

    scenario "Specify a class as a dependency", ->
    
        container = driver = null
    
        Given "I have a container with a class mapping registered", ->
            container = new core.Container
            
            # 
            container.register_class "Driver", Driver
    
        When "I resolve a new instance of the mapping with the container", ->
            driver = container.resolve( "Driver" )
    
        Then "the container should resolve an instance of the class", ->
            expect( driver instanceof Driver ).toBeTruthy()
            
        And "each call to resolve another class instantiates a new instance", ->
            expect( container.resolve( "Driver" ) ).not.toBe( driver )
            
    scenario "Specify a singleton class as a dependency", ->
    
        container = repository = null
        
        Given "I have a container with a singleton class mapping", ->
            container = new core.Container
            container.register_class "Repository", HttpRepository, singleton: true
            
        When "I resolve an instance of the class", ->
            repository = container.resolve( "Repository" )
            
        Then "the container should resolve an instance of the class", ->
            expect( repository instanceof HttpRepository ).toBeTruthy()
            
        And "the container resolves to the same instance each time", ->
            expect( container.resolve( "Repository" ) ).toBe( repository )
            
