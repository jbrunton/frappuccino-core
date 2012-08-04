describe "core.Model", ->

    describe "@attr", ->
    
        it "defines an attribute for the type definition", ->
            MyModel = class extends core.Model
                @attr foo: "string"
                
            expect( MyModel.ty_def() ).toEqual attr:
                foo:
                    ty_name: "string"
            
        it "accepts an optional primary_key flag", ->
            MyModel = class extends core.Model
                @attr foo: "string",
                    primary_key: true
                
            expect( MyModel.ty_def() ).toEqual attr:
                foo:
                    ty_name: "string"
                    primary_key: true
                    
        it "can be passed a string instead of an object", ->
            MyModel = class extends core.Model
                @attr "foo",
                    attr_type: "string"
                    
            expect( MyModel.ty_def() ).toEqual attr:
                foo:
                    ty_name: "string"

        it "assumes an 'id' attribute is a primary key", ->
            MyModel = class extends core.Model
                @attr id: "number"
                
            expect( MyModel.ty_def() ).toEqual attr:
                id:
                    ty_name: "number"
                    primary_key: true                    
            
    describe "@attr_accessible", ->
        
        it "defines the attributes which should be serialized by default", ->
            MyModel = class extends core.Model
                @attr foo: "string"
                @attr bar: "string"
                @attr_accessible "foo"
                
            expect( MyModel.ty_def() ).toEqual attr:
                foo:
                    ty_name: "string"
                    accessible: true
                bar:
                    ty_name: "string"

    describe "@has_many", ->
    
        it "defines an association for the underlying type", ->
            MyModel = class extends core.Model
                @has_many "words",
                    underlying_type: "string"
                    
            expect( MyModel.ty_def() ).toEqual attr:
                words:
                    ty_name: "List[string]"
                    association: true
    
        it "infers the underlying type if none is provided", ->
            Blog = class extends core.Model
                @has_many "blog_posts"
                
            expect( Blog.ty_def() ).toEqual attr:
                blog_posts:
                    ty_name: "List[blog_post]"
                    association: true
        
    describe "@belongs_to", ->
    
        it "defines an association for the underlying type and adds a foreign key attribute", ->
            Blog = class extends core.Model
                @belongs_to "user",
                    underlying_type: "person"
                    
            expect( Blog.ty_def() ).toEqual attr:
                user:
                    ty_name: "person"
                    association: true
                user_id:
                    ty_name: "number"
            
        it "infers the underlying type if none is provided", ->
            Blog = class extends core.Model
                @belongs_to "user"
                
            expect( Blog.ty_def() ).toEqual attr:
                user:
                    ty_name: "user"
                    association: true
                user_id:
                    ty_name: "number"
                    
    describe "@has_one", ->
    
        it "defines an association for the underlying type", ->
            Blog = class extends core.Model
                @has_one "blog_post",
                    underlying_type: "content"
                    
            expect( Blog.ty_def() ).toEqual attr:
                blog_post:
                    ty_name: "content"
                    association: true
            
        it "infers the underlying type if none is provided", ->
            Blog = class extends core.Model
                @has_one "blog_post"
                
            expect( Blog.ty_def() ).toEqual attr:
                blog_post:
                    ty_name: "blog_post"
                    association: true

    describe "@validates", ->
    
        it "adds the relevant validators to the prototype", ->
            Blog = class extends core.Model
                @attr title: "string"
                @validates "title", presence: true
            
            # TODO: this is not really a unit test - make a feature test instead, maybe?
            expect( Blog::validators ).toContain( jasmine.any(core.validators.PresenceValidator) )