namespace "core", ->

    class @Decorator
    
        decorate: ( target, decorator, args... ) ->
        
            for key, value of decorator::
                target[key] = value
            
            decorator.apply( target )