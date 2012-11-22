class core.routes.Dispatcher

    constructor: ( @app, @controller_name, @action_name ) ->
    
    dispatch: =>
        @controller = @app.modules["#{@controller_name}_controller"] unless @controller?
        @app.request =
            active_controller: @controller
        @controller[@action_name].apply( @controller, arguments )
  