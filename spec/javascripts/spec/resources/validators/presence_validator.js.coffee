describe "core.validators.PresenceValidator", ->

    blog_post = validator = null

    beforeEach ->
        blog_post =
            title: ->
            validation_error: ->
            
        validator = new core.validators.PresenceValidator( "title" )
        spyOn( blog_post, "validation_error" )

    it "should validate a field which is present", ->
        spyOn( blog_post, "title" ).andReturn( "Some Title" )
        validator.validate( blog_post )
        expect( blog_post.validation_error ).not.toHaveBeenCalled()
    
    it "should error on a field which isn't defined", ->
        spyOn( blog_post, "title" ).andReturn( null )
        validator.validate( blog_post )
        expect( blog_post.validation_error ).toHaveBeenCalledWith( jasmine.any(String), "title" )

    it "should error on a field which is the empty string", ->
        spyOn( blog_post, "title" ).andReturn( "" )
        validator.validate( blog_post )
        expect( blog_post.validation_error ).toHaveBeenCalledWith( jasmine.any(String), "title" )
        
        