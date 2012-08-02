namespace "core", ->

    @include = ( target, module ) ->
        for key, value of module
            target[key] = value
            
        for key, value of module::
            target::[key] = value
