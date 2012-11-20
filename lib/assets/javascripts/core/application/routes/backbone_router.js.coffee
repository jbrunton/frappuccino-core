namespace "core.routes"

Backbone = {} unless Backbone?

class core.routes.BackboneRouter extends Backbone

    constructor: ( @app ) ->

    route: ( url, controller_name, action_name ) ->
        dispatcher = new core.routes.Dispatcher( @app, controller_name, action_name )
        super( url, action_name, dispatcher.dispatch )
    
    navigate_handler: ( event ) =>
        event.preventDefault()
        href = $(event.currentTarget).attr( "href" )
        @navigate( href )    

    initialize: ->
            self = @
            $(document).on "click", ".nav-to",
                (event) ->
                    event.preventDefault()
                    href = $(event.currentTarget).attr( "href" )
                    self.navigate( href )