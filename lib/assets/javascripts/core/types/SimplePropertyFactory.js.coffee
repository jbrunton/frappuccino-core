namespace "core.types", ->

    class @SimplePropertyFactory
    
        createProperty: (initVal) ->
            val = initVal
            ->
                if arguments.length
                    val = arguments[0]
                else
                    val
        
        createArrayProperty: (initVal) ->
            @createProperty initVal
            
    class @KoPropertyFactory
    
        createProperty: (initVal) ->
            ko.observable initVal
            
        createArrayProperty: (initVal) ->
            ko.observableArray initVal