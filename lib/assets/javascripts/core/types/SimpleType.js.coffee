@namespace "core.types"

class core.types.SimpleType

    constructor: (@tyName, @serialize, @deserialize) ->
        @kind = "simple"
        @serialize = ((x) -> x) unless @serialize
        @deserialize = ((x) -> x) unless @deserialize
            