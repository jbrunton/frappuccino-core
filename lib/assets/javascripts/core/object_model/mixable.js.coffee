namespace "core", ->

    class @Mixable
    
        @include: (mixin) ->
            for key, value of mixin
                @[key] = value
                
            for key, value of mixin::
                @::[key] = value
            
            mixin.apply(@)