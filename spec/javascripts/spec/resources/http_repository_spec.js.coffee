describe "core.resources.HttpRepository", ->

    http_repository = null
    
    beforeEach ->
        http_repository = new core.resources.HttpRepository

    describe "#gen_req_params", ->
    
        it "generates query params for followed associations", ->
            
            query_params = http_repository.gen_req_params(blog: true, recent_posts: true)
            expect(query_params).toBe("include=blog,recent_posts")
            
        it "generates query params for nested associations", ->
        
            query_params = http_repository.gen_req_params(user: { blog: { blog_posts: true } })
            expect(query_params).toBe("include=user.blog.blog_posts")
            