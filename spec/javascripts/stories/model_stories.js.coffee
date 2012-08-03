#= require helpers/test_bootstrapper

feature "core.Model", ->
        
    summary(
        'As a client of the framework',
        'I want to create, read, update and destory resources through a repository'
    )

    scenario "initialize model classes", ->
    
        app = bootstrapper = Blog = BlogPost = null
        
        Given "I have an application and a bootstrapper", ->
            app = new core.Application
            bootstrapper = test_helper.Bootstrapper()
        
        When "I configure and run the application with the bootstrapper", ->
            Blog = class extends core.Model
                @attr id: "number"
                @attr title: "string"
                @has_many "blog_posts", underlying_type: "blog_post"

                @attr_accessible "title", "blog_posts"
                
            BlogPost = class extends core.Model
                @attr id: "number"
                @attr content: "string"

                @attr_accessible "content"
                
            app.config "app.models",
                Blog: Blog
                BlogPost: BlogPost
                
            app.run( bootstrapper )
            
        Then "the application environment should be configured with the application models", ->
            #my_model = app.env.create( "my_model" )
            #expect( my_model instanceof MyModel ).toBe true
            
            #my_model = new MyModel()
            #expect( my_model instanceof MyModel ).toBe true
            #expect( my_model.env ).toBe app.env
            
        And "the serialize method should serialize accessible attributes by default", ->
            blog = new Blog( title: "blog title" )
            expect( blog.serialize() ).toEqual( title: "blog title" )
            
        And "the serialize method should follow accessible associations", ->
        
            blog = new Blog( title: "blog title", blog_posts: [ content: "some example content" ] )
            expect( blog.serialize() ).toEqual( title: "blog title", blog_posts_attributes: [ content: "some example content" ] )
            
        And "the serialize method should include primary keys for nested associations", ->
            blog = new Blog( id: 1, title: "blog title", blog_posts: [ id: 2, content: "some example content" ] )
            expect( blog.serialize() ).toEqual( title: "blog title", blog_posts_attributes: [ id: 2, content: "some example content" ] )
            
            #expect( blog.serialize() ).toEqual( blog_posts: [ id: 1, content: "some example content" ] )