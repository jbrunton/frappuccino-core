namespace "core", ->

    class @Decoratable
    
        decorate: ( target, decorator, args... ) ->
        
            for key, value of decorator::
                target[key] = value
            
            decorator.apply( target )