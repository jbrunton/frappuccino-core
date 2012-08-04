describe "core.ModelErrors", ->

    errors = null

    beforeEach ->
        errors = new core.ModelErrors

    describe "#add", ->
    
        it "adds an error message for the specified attribute", ->
            errors.add( "title", "please enter a title" )
            expect( errors["title"] ).toContain( "please enter a title" )
            
    describe "#clear", ->
    
        it "removes all error messages from the object", ->
            errors.add( "email", "please enter a valid email address" )
            expect( errors["email"] ).toBeDefined()
            
            errors.clear()
            expect( errors["email"] ).toBeUndefined()
            