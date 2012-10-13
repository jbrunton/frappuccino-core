namespace "core", ->

    class @ApplicationModule extends core.EventObject    
        constructor: (@name) ->
        
        @dependency sandbox: (container) ->
            container.resolve "Sandbox", [@]
        @dependency env: "Environment"
        
        @dependency container: (container) ->
            container.child().register_instance "Sandbox", @sandbox
   
        @dependency renderer: "Renderer"
        @dependency router: "Router"
        
        publish: ->
            @sandbox.publish.apply( sandbox, arguments )
            
        bind_subscriptions: (target) ->
            @sandbox.bind_subscriptions.apply( @sandbox, [target] )
            target.publish = @sandbox.publish
            
        create_model: ( class_name, opts ) ->
            @env.create( class_name, opts )
            
#        decorate: ( target, decorator, args... ) ->
#        
#            for key, value of decorator::
#                target[key] = value
#            
#            decorator.apply( target )
        
    #class @ModuleCatalog
    
    #    constructor: ->
    #        @modules = []
            
    #    registerModule: ( klass, name ) ->
    #        @modules.push { klass: klass, name: name }
            
        #resolve: (app, container) ->
        #    for { cls } in @modules
        #        app.registerModule( container.resolve( new cls( 