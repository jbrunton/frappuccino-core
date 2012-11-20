describe "core.validators.FormatValidator", ->

    blog_post = validator = null

    beforeEach ->
        blog_post =
            title: ->
            validation_error: ->
            
        spyOn( blog_post, "validation_error" )

    it "should validate a valid format" , ->
        opts =
            with: /^[A-Z]/
        validator = new core.validators.FormatValidator( "title", opts)
        spyOn( blog_post , "title" ).andReturn( "Blog Title" )
        validator.validate( blog_post )
        expect( blog_post.validation_error ).not.toHaveBeenCalled()

    it "should error an invalid format" , ->
        opts =
            with: /^[A-Z]/
        validator = new core.validators.FormatValidator( "title", opts)
        spyOn( blog_post , "title" ).andReturn( "blog Title" )
        validator.validate( blog_post )
        expect( blog_post.validation_error ).toHaveBeenCalled()