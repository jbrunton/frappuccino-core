class core.routes.Dispatcher

    constructor: ( @app, @controller_name, @action_name ) ->
    
    dispatch: =>
        @controller = @app.controllers["#{@controller_name}_controller"] unless @controller?
        @controller[@action_name].apply( @controller, arguments )
  