namespace "core"

class core.ModelErrors

    constructor: ->
        @_attributes = []
        @count = 0
        
    add: ( attribute, message ) ->
        @[attribute] ?= []
        ( @[attribute] ).push( message )
        @_attributes.push( attribute ) unless _.include( @_attributes, attribute )
        @count += 1
        
    clear: ->
        for attribute in @_attributes
            delete @[attribute]
        @_attributes.length = 0
        @count = 0
        
    is_valid: ( attribute ) ->
        _.include( @_attributes, attribute )
            