namespace "core", ->

    @extend = ( target, module ) ->
        for key, value of module::
            target[key] = value
