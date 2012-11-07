namespace "core.types"

class core.types.SimplePropertyFactory

    createProperty: (initVal) ->
        val = initVal
        ->
            if arguments.length
                val = arguments[0]
            else
                val
    
    createArrayProperty: (initVal) ->
        @createProperty initVal
        
class core.types.KoPropertyFactory

    createProperty: (initVal) ->
        prop = ko.observable initVal
        prop.is_valid = ko.observable(true)
        prop
        
    createArrayProperty: (initVal) ->
        prop = ko.observableArray initVal
        prop.is_valid = ko.observable(true)
        prop