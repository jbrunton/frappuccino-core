namespace "core.util"

# Returns a deep copy of the given object or Date.
#
# @param obj [Object] the object to copy.
# @return [Object] a new copy of the object.
#
core.util.clone = (obj) ->
    
        if not obj? or typeof obj isnt 'object'
            return obj
    
        if obj instanceof Date
            return new Date(obj.getTime()) 
    
        clone = new obj.constructor()
    
        for key of obj
            clone[key] = core.util.clone obj[key]
    
        return clone