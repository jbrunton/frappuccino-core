describe "core.validators.PresenceValidator", ->

    blog_post = validator = null

    beforeEach ->
        blog_post =
            title: ->
            errors:
                add: ->
            
        spyOn( blog_post.errors, "add" )
            
        validator = new core.validators.PresenceValidator( "title" )

    it "should validate a field which is present", ->
        spyOn( blog_post, "title" ).andReturn( "Some Title" )
        validator.validate( blog_post )
        expect( blog_post.errors.add ).not.toHaveBeenCalled()
    
    it "should error on a field which isn't defined", ->
        spyOn( blog_post, "title" ).andReturn( null )
        validator.validate( blog_post )
        expect( blog_post.errors.add ).toHaveBeenCalledWith( "title", jasmine.any(String) )

    it "should error on a field which is the empty string", ->
        spyOn( blog_post, "title" ).andReturn( "" )
        validator.validate( blog_post )
        expect( blog_post.errors.add ).toHaveBeenCalledWith( "title", jasmine.any(String) )
        
        