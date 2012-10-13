describe "core.DependentObject", ->

    container = null
    
    class Hat extends core.DependentObject
        constructor: ( @type = "trilby", @color = "black" ) ->

    beforeEach ->
        container = new core.Container
    
    it "specifies simple dependencies", ->
        class Person extends core.DependentObject
            @dependency hat: "Hat"

        expect( Person::dependencies ).toEqual( hat: ["Hat", []] )
        
    it "specifies dependency arguments", ->
        class Person extends core.DependentObject
            @dependency hat: "Hat", "cap", "white"
            
        expect( Person::dependencies ).toEqual( hat: ["Hat", ["cap", "white"]] )
        
    it "specifies dependencies with constructor functions", ->
        constructor = ( container ) ->
            container.resolve "Hat"
        
        class Person extends core.DependentObject
            @dependency hat: constructor
      
        expect( Person::dependencies ).toEqual( hat: [constructor, []] )
        
    