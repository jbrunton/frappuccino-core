describe "core.routes.Mapper", ->

    mapper = null
    
    beforeEach ->
        mapper = new core.routes.Mapper
        mapper.router = jasmine.createSpyObj 'router', ['route']

    describe "#match", ->
    
        it "routes a simple url to a specified controller and action", ->
            mapper.match 'users/:id/view', controller: 'users', action: 'view'
            expect( mapper.router.route ).toHaveBeenCalledWith 'users/:id/view', 'users', 'view'

    describe "#resource", ->
    
        it "routes a series of RESTful URLs to corresponding actions on the relevant controller", ->
            mapper.resource 'users'
            expect( mapper.router.route ).toHaveBeenCalledWith 'users/:id/view', 'users', 'view'
            expect( mapper.router.route ).toHaveBeenCalledWith 'users/:id/edit', 'users', 'edit'
