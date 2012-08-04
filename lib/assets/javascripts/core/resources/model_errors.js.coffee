namespace "core", ->

    class @ModelErrors
    
        constructor: ->
            @_attributes = ko.observableArray([])
            @count = 0
            
        add: ( attribute, message ) ->
            @[attribute] ?= []
            ( @[attribute] ).push( message )
            @_attributes.push( attribute ) unless _.include( @_attributes(), attribute )
            @count += 1
            
        clear: ->
            for attribute in @_attributes
                delete @[attribute]
            @_attributes([])
            @count = 0
            
        is_valid: ( attribute ) ->
            ko.computed( (-> _.include( @_attributes(), attribute )), @)
            