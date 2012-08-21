#= require helpers/test_bootstrapper

feature "core.ModelValidator", ->
        
    summary(
        'As a client of the framework',
        'I wish to validate model classes'
    )

    scenario "basic validatation", ->
    
        app = bootstrapper = BlogPost = null
        
        Given "I have an application and a bootstrapper", ->
            app = new core.Application
            bootstrapper = test_helper.Bootstrapper()
        
        When "I configure and run the application with the bootstrapper", ->
            BlogPost = class extends core.Model
                @attr "id"
                @attr "title"
                
                @validates "title", presence: true
                
            app.config "app.models",
                BlogPost: BlogPost
                
            app.run( bootstrapper )
            
        Then "I should be able to validate the model", ->
            blog_post = new BlogPost
            expect( blog_post.validate() ).toBe( false )
            
            blog_post.title( "Some Title" )
            expect( blog_post.validate() ).toBe( true )
