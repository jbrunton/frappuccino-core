namespace "core", ->

    class @BaseObject
    
        @include: ( module ) ->
            core.include( @, module )
            
        decorate: ->
            core.decorate( arguments... )