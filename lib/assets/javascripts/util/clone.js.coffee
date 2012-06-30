namespace "core.util", ->
    
    @clone = (obj) ->
    
        if not obj? or typeof obj isnt 'object'
            return obj
    
        if obj instanceof Date
            return new Date(obj.getTime()) 
    
        clone = new obj.constructor()
    
        for key of obj
            clone[key] = core.util.clone obj[key]
    
        return clone