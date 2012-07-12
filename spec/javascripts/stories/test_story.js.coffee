feature "Application Bootstrapper", ->

    class MyBootstrapper extends core.Bootstrapper
    
        # TODO: remove app param, and register Renderer as a singleton type
        configure_container: ->
            container = super()
            
            # container.registerClass "Application", app.Application, singleton: true
            container.register_class "Renderer", {}, singleton: true
            container.register_class "Router", {}, singleton: true
            container.register_class "PropertyFactory", core.types.SimplePropertyFactory, singleton: true
            container.register_class "ModelRepository", core.resources.LocalResourceHandler, singleton: true

            # TODO: move this to a resources controller which reads from the api feed
            env = container.resolve "Environment"
            
            env.defineSimpleType "number"
            env.defineSimpleType "string"


            formatDate = (date) ->
                if date
                    date.toString()
                else
                    null
        
            parseDate = (value) ->
                # 2012-03-15T23:02:29Z
                regex = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z$/
        
                if (value)
                    match = value.match(regex)
                    new Date(
                        parseInt(match[1]),
                        parseInt(match[2]),
                        parseInt(match[3]),
                        parseInt(match[4]),
                        parseInt(match[5]),
                        parseInt(match[6]))
                else
                    null

            env.defineSimpleType "datetime", formatDate, parseDate
                                            
            container
            
        initialize: ->
            # random final initialization phase
            # TODO: there's probably somewhere better to put this
            # ko.setTemplateEngine( new infrastructure.UnderscoreTemplateEngine( @application ) )
            #_.templateSettings =
            #    interpolate: /\{\{(.+?)\}\}/g
            #    evaluate: /\{\[(.+?)\]\}/g
                
    class MyApplication extends core.Application

        run: ( bootstrapper_class ) ->
            bootstrapper = super( bootstrapper_class )
            bootstrapper.initialize()
        
    summary(
        'As a client of the framework',
        'I want to run my application'
    )

    scenario "Run an application with a bootstrapper", ->
    
        app = null

        Given "I have an application and bootstrapper class", ->
            app = new MyApplication
    
        When "I run the application", ->
            app.run( MyBootstrapper )
    
        Then "the application should be running", ->
            (expect app.running).toBe true
            
        And "foo", ->
        
    scenario "core.Bootstrapper initializes the environment with classes in app.models", ->
    
        my_app = null
        
        window.app =
            models:
                MyModel: class extends core.Model
        
        Given "I have an application and bootstrapper", ->
            my_app = new MyApplication
        
        When "I run the application", ->
            my_app.run( MyBootstrapper )
            
        Then "the application environment should be configured with models in the app.models namespace", ->
            my_model = my_app.env.create( "my_model" )
            expect( my_model instanceof app.models.MyModel ).toBe true