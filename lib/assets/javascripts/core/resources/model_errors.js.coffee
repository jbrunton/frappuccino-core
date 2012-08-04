namespace "core", ->

    class @ModelErrors
    
        constructor: ->
            @_attributes = []
            @count = 0
            
        add: ( attribute, message ) ->
            @[attribute] ?= []
            ( @[attribute] ).push( message )
            @_attributes.push( attribute )
            @count += 1
            
        clear: ->
            for attribute in @_attributes
                delete @[attribute]
            @_attributes.length = 0
            @count = 0
            