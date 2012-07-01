@namespace "core.types", ->

    class @SimpleType
    
        constructor: (@tyName, @serialize, @deserialize) ->
            @kind = "simple"
            @serialize = ((x) -> x) unless @serialize
            @deserialize = ((x) -> x) unless @deserialize
            