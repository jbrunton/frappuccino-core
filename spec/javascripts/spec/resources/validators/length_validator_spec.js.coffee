describe "core.validators.LengthValidator", ->

    blog_post = validator = test_message = null

    beforeEach ->
    	test_message = "Test Message"
    	blog_post =
            title: ->
            validation_error: ->
        opts_8_10 =
            min: 8
            max: 10
            message: test_message
        attribute = "title"
        validator = new core.validators.LengthValidator attribute, opts_8_10
        spyOn( blog_post, 'validation_error' )

    it "should validate for a suitable length" , ->
    	spyOn( blog_post, "title" ).andReturn( "Just Right" )
    	validator.validate(blog_post)
    	expect( blog_post.validation_error ).not.toHaveBeenCalled()

    it "should error on a short length and return the given message" , ->
    	spyOn( blog_post, "title" ).andReturn( "Short" )
    	validator.validate(blog_post)
    	expect( blog_post.validation_error ).toHaveBeenCalledWith(test_message, 'title')

    it "should error on a long length and return the given message" , ->
    	spyOn( blog_post, "title" ).andReturn( "Title Is Too Long" )
    	validator.validate(blog_post)
    	expect( blog_post.validation_error ).toHaveBeenCalledWith(test_message, 'title')

    it "should error and return the correct default message when a message is not provided" , ->
    	spyOn( blog_post, "title" ).andReturn( "Title Is.." )

    	opts_max4 =
            max: 4
        opts_min12 =
    	    min: 12
    	opts_2_4 =
    		min: 2
    		max: 4
    
    	validator_max4 = new core.validators.LengthValidator 'title', opts_max4
    	validator_min12 = new core.validators.LengthValidator 'title', opts_min12
    	validator_2_4 = new core.validators.LengthValidator 'title', opts_2_4

    	validator_max4.validate(blog_post)
    	validator_min12.validate(blog_post)
    	validator_2_4.validate(blog_post)

    	expect( blog_post.validation_error.calls.length ).toEqual(3)
    	expect( blog_post.validation_error ).toHaveBeenCalledWith('please enter at most 4 characters', 'title')
    	expect( blog_post.validation_error ).toHaveBeenCalledWith('please enter at least 12 characters', 'title')
    	expect( blog_post.validation_error ).toHaveBeenCalledWith('please enter between 2 and 4 characters', 'title')