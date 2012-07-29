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
    
        it "implicity infers the underlying type if none is provided", ->
            Blog = class extends core.Model
                @has_many "blog_posts"
                
            expect( Blog.ty_def() ).toEqual attr:
                blog_posts:
                    ty_name: "List[blog_post]"
                    association: true
        