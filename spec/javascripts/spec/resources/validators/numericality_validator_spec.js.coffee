describe "core.validators.NumericalityValidator", ->

    post = post2 = opts = null

    beforeEach ->
        opts = {}
        post = 
            value: ->
            validation_error: ->        
        post2 = 
            value: ->
            validation_error: ->
        spyOn(post , 'validation_error')
        spyOn(post2 , 'validation_error')

    describe "#base", ->

        it "should recognise a valid number" , ->
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(1)
            validator.validate(post)
            expect(post.validation_error).not.toHaveBeenCalled()

        it "should error a non-numeric value" , ->
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn('not a numeric value')
            validator.validate(post)
            expect(post.validation_error).toHaveBeenCalled()

    describe "#only_integer", ->

        it "should validate a valid integer when only_integer is true", ->
            opts =
                only_integer: true
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(1)
            validator.validate(post)
            expect(post.validation_error).not.toHaveBeenCalled()

        it "should error on a decimal when only_integer is true" , ->
            opts =
                only_integer: true
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(1.5)
            validator.validate(post)
            expect(post.validation_error).toHaveBeenCalled()

    describe "#greater_than", ->
        it "should validate a value greater than the limit" , ->
            opts =
                greater_than: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(15)
            validator.validate(post)
            expect(post.validation_error).not.toHaveBeenCalled()    

        it "should error a value not greater than the limit" , ->
            opts =
                greater_than: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(5)
            validator.validate(post)
            expect(post.validation_error).toHaveBeenCalled()

    describe "#greater_than_or_equal_to", ->

        it "should validate a value greater than or equal to the limit" , ->
            opts =
                greater_than_or_equal_to: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(15)
            spyOn(post2, 'value').andReturn(10)
            validator.validate(post)
            validator.validate(post2)
            expect(post.validation_error).not.toHaveBeenCalled()
            expect(post2.validation_error).not.toHaveBeenCalled()

        it "should error a value not greater than or equal to the limit" , ->
            opts =
                greater_than_or_equal_to: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(5)
            validator.validate(post)
            expect(post.validation_error).toHaveBeenCalled()

    describe "#equal_to", ->

        it "should validate a value equal to the limit" , ->
            opts =
                equal_to: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(10)
            validator.validate(post)
            expect(post.validation_error).not.toHaveBeenCalled()


        it "should error a value that is not equal to the limit" , ->
            opts =
                equal_to: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(15)
            validator.validate(post)
            expect(post.validation_error).toHaveBeenCalled()

    describe "#less_than", ->

        it "should validate a value less than the limit" , ->
            opts =
                less_than: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(5)
            validator.validate(post)
            expect(post.validation_error).not.toHaveBeenCalled()

        it "should error a value not less than the limit" , ->
            opts =
                less_than: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(15)
            validator.validate(post)
            expect(post.validation_error).toHaveBeenCalled()

    describe "#less_than_or_equal_to", ->

        it "should validate a value less than or equal to the limit" , ->
            opts =
                less_than_or_equal_to: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(5)
            spyOn(post2, 'value').andReturn(10)
            validator.validate(post)
            validator.validate(post2)
            expect(post.validation_error).not.toHaveBeenCalled()
            expect(post2.validation_error).not.toHaveBeenCalled()

        it "should error a value not less than or equal to the limit" , ->
            opts =
                less_than_or_equal_to: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(15)
            validator.validate(post)
            expect(post.validation_error).toHaveBeenCalled()

    describe "#odd", ->

        it "should validate a value that is odd" , ->
            opts =
                odd: true
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(7)
            validator.validate(post)
            expect(post.validation_error).not.toHaveBeenCalled()

        it "should error a value that is not odd" , ->
            opts =
                odd: true
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(8)
            validator.validate(post)
            expect(post.validation_error).toHaveBeenCalled()

    describe "#even", ->

        it "should validate a value that is even" , ->
            opts =
                even: true
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(4)
            validator.validate(post)
            expect(post.validation_error).not.toHaveBeenCalled()

        it "should error a value that is not even" , ->
            opts =
                even: true
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(5)
            validator.validate(post)
            expect(post.validation_error).toHaveBeenCalled()

    describe "#even & greater_than", ->

        it "should validate a value that is even and greater than the limit", ->
            opts =
                even: true
                greater_than: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(16)
            validator.validate(post)
            expect(post.validation_error).not.toHaveBeenCalled()

        it "should error a value that is greater than the limit and not even", ->
            opts =
                even: true
                greater_than: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(21)
            validator.validate(post)
            expect(post.validation_error).toHaveBeenCalled()

        it "should validate a value that is even but not greater than the limit", ->
            opts =
                even: true
                greater_than: 10
            validator = new core.validators.NumericalityValidator 'value' , opts
            spyOn(post, 'value').andReturn(8)
            validator.validate(post)
            expect(post.validation_error).toHaveBeenCalled()