describe "core.support.Inflector", ->

    inflector = null
    
    beforeEach ->
        inflector = new core.support.Inflector

    describe "#underscore", ->
        
        it "converts camel case words to lowercase, underscored", ->
            expect( inflector.underscore( "MyModule" ) ).toBe( "my_module" )
                
    describe "#camelize", ->
        
        it "converts underscored words to camel case", ->
            expect( inflector.camelize( "my_module" ) ).toBe( "MyModule" )
                
    describe "#pluralize", ->
    
        it "converts singular words to regular plurals", ->
            expect( inflector.pluralize( "my_module" ) ).toBe( "my_modules" )
                
        it "converts singular words to the specified irregular plural form", ->
            expect( inflector.pluralize( "vertex" ) ).toBe( "vertices" )
            
                
    describe "#singularize", ->
    
        it "converts regular plurals to the singular form", ->
            expect( inflector.singularize( "my_modules" ) ).toBe( "my_module" )
    
        it "converts irregular plural words to the specified singular form", ->
            expect( inflector.singularize( "vertices" ) ).toBe( "vertex" )
    
    describe "#tableize", ->
    
        it "converts an underscored, plural table name to a camel case, singular class name", ->
            expect( inflector.tableize( "SomeClass" ) ).toBe( "some_classes" )
            
    describe "#classify", ->
    
        it "converts a camel case, singular class name to an underscored, plural table name", ->
            expect( inflector.classify( "some_classes") ).toBe( "SomeClass" )
            
describe "core.support.inflector", ->

    it "is an instance of core.support.Inflector", ->
        expect( core.support.inflector ).toBeDefined()
        expect( core.support.inflector instanceof core.support.Inflector ).toBe( true )
        