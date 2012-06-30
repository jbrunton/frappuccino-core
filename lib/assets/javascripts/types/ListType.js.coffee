namespace "core.types", ->

    class @ListType
    
        constructor: (@baseTy) ->
            @kind = "list"
        
        serialize: (list, env, includeSpec) ->
            @baseTy.serialize elem, env, includeSpec for elem in list
        
        deserialize: (array, env) ->
            if _.isUndefined array
                []
            else
                @baseTy.deserialize elem, env for elem in array
        