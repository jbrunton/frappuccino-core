namespace "core"

# Implements convenience methods to include mixins and decorate instances.
#
class core.BaseObject

    # Static method to include a module into a class.
    #
    # @param module [Object] the module to include.
    #
    @include: ( module ) ->
        core.include( @, module )

    # Decorates an instance with the given decorator.
    #
    decorate: ->
        core.decorate( @, arguments... )