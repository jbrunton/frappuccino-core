describe "core.validators.ConfirmationValidator", ->

    blog_post = validator = null

    beforeEach ->
        blog_post =
            email: ->
            email_confirmation: ->
            validation_error: ->

        opts =
            message:  "testmessage"
            min: 5

        validator = new core.validators.ConfirmationValidator "email" , opts
        spyOn( blog_post, "validation_error" )


    it "should confirm the email address input correctly twice" , ->
        spyOn( blog_post , "email" ).andReturn( "email@domain.com" )
        spyOn( blog_post , "email_confirmation" ).andReturn( "email@domain.com" )
        validator.validate( blog_post )
        expect(blog_post.validation_error).not.toHaveBeenCalled()

    it "should error when email address is different to confirmation email" , ->
        spyOn( blog_post , "email" ).andReturn( "email@domain.com" )
        spyOn( blog_post , "email_confirmation" ).andReturn( "different_email@domain.com" )
        validator.validate( blog_post )
        expect(blog_post.validation_error).toHaveBeenCalled()