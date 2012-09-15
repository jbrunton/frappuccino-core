describe "core.Model", ->

    describe "@attr", ->
    
        it "defines an attribute with default type 'Inherit'", ->
            User = class extends core.Model
                @attr "email"
                
            expect( User::attributes["email"] ).toEqual(
                class_name: "Inherit" )
            
        it "accepts an optional primary_key flag", ->
            User = class extends core.Model
                @attr "email", primary_key: true
                
            expect( User::attributes["email"] ).toEqual(
                class_name: "Inherit",
                primary_key: true )
                    
        it "implicitly assume an 'id' attribute is a primary key", ->
            User = class extends core.Model
                @attr "id"
                
            expect( User::attributes["id"] ).toEqual(
                class_name: "Inherit",
                primary_key: true )
            
    describe "@attr_serialize", ->
        
        it "defines the attributes which should be serialized by default", ->
            User = class extends core.Model
                @attr "email"
                @attr "password"
                @attr_serialize "email"
                
            expect( User::attributes["email"] ).toEqual(
                class_name: "Inherit",
                serialize: true )

    describe "@has_many", ->
    
        it "defines an association of items of the given class", ->
            User = class extends core.Model
                @has_many "recent_posts",
                    class_name: "BlogPost"
                    
            expect( User::attributes["recent_posts"] ).toEqual(
                class_name: "List[BlogPost]",
                association: true )
    
        it "infers the class name if none is provided", ->
            User = class extends core.Model
                @has_many "blog_posts"
                
            expect( User::attributes["blog_posts"] ).toEqual(
                class_name: "List[BlogPost]",
                association: true )
        
    describe "@belongs_to", ->
    
        it "defines an association of items of the given class, and adds a foreign key attribute", ->
            Blog = class extends core.Model
                @belongs_to "user", class_name: "Person"
                    
            expect( Blog::attributes ).toEqual(
                user:
                    class_name: "Person"
                    association: true
                user_id:
                    class_name: "Inherit" )
            
        it "infers the underlying type if none is provided", ->
            Blog = class extends core.Model
                @belongs_to "user"
                
            expect( Blog::attributes ).toEqual(
                user:
                    class_name: "User"
                    association: true
                user_id:
                    class_name: "Inherit" )
                    
    describe "@has_one", ->
    
        it "defines an association for the given class", ->
            Blog = class extends core.Model
                @has_one "blog_post",
                    class_name: "content"
                    
            expect( Blog::attributes["blog_post"] ).toEqual(
                class_name: "content",
                association: true )
            
        it "infers the class if none is provided", ->
            Blog = class extends core.Model
                @has_one "blog_post"
                
            expect( Blog::attributes["blog_post"] ).toEqual(
                class_name: "BlogPost",
                association: true )

    describe "@validates", ->
    
        #it "adds the relevant validators to the prototype", ->
            #Blog = class extends core.Model
            #    @attr title: "string"
            #    @validates "title", presence: true
            
            # TODO: this is not really a unit test - make a feature test instead, maybe?
            # expect( Blog::validators ).toContain( jasmine.any(core.validators.PresenceValidator) )

            
