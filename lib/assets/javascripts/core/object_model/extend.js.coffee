namespace "core"

# Extends the target with methods from the given module's prototype.
#
# @param target [Object/Class] the object or class to extend.
# @param module [Class] the module to mixin.
#
core.extend = ( target, module ) ->
    for key, value of module::
        target[key] = value
