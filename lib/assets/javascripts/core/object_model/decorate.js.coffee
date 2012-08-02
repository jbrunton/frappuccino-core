namespace "core", ->

    @decorate = ( target, decorator, args... ) ->
    
        core.extend( target, decorator )
        decorator.apply( target, args )