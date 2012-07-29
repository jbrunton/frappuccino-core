namespace "core.types", ->

    class @ListType
    
        constructor: (@baseTy) ->
            @kind = "list"
        
        serialize: (list, env, includeSpec, nested) ->
            @baseTy.serialize elem, env, includeSpec, nested for elem in list unless _.isUndefined list
        
        deserialize: (array, env) ->
            @baseTy.deserialize elem, env for elem in array unless _.isUndefined array
        