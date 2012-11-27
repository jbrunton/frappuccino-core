namespace "core.routes"

BackboneRouter = Backbone?.Router || {}

class core.routes.BackboneRouter extends BackboneRouter

    core.DependentModule.dependency.call @, app: "Application"

    route: ( url, controller_name, action_name ) ->
        dispatcher = new core.routes.Dispatcher( @app, controller_name, action_name )
        super( url, action_name, dispatcher.dispatch )
    
    navigate_handler: ( event ) =>
        event.preventDefault()
        href = $(event.currentTarget).attr( "href" )
        @navigate( href, true )    

    initialize: ->
        $(document).on "click", ".nav-to", @navigate_handler