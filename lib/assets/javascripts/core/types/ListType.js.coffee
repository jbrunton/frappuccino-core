namespace "core.types"

class core.types.ListType

    constructor: (@baseTy) ->
        @kind = "list"
    
    serialize: (list, env, includeSpec, nested) ->
        filtered_list = _.reject list, (item) ->
            item._destroy and item._destroy() and
            item.is_new_record? and item.is_new_record()
        @baseTy.serialize elem, env, includeSpec, nested for elem in filtered_list unless _.isUndefined list
    
    deserialize: (array, env) ->
        @baseTy.deserialize elem, env for elem in array unless _.isUndefined array
        