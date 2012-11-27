describe "core.validators.BaseValidator", ->

    blog_post = validator = opts = null

    beforeEach ->
        opts =
            message: "test message"
            param_1: "limit 1"
            param_2: "limit 2"          

        validator = new core.validators.BaseValidator "" , opts

    it "should initialise attributes identified from the opts" , ->
        validator.initialize_attributes opts , "message", "param_1"
        expect(validator.message).toBe("test message")
        expect(validator.param_1).toBe("limit 1")

    it "should not initialise attributes not identified from the opts" , ->
        validator.initialize_attributes opts , "message", "param_1"
        expect(validator.param_2).not.toBeDefined()

    it "should not throw an exception initialising attributes when opts is not an object" , ->
        foo = ->
            validator.initialize_attributes true , "message"
        expect(foo).not.toThrow()