xdescribe "core.DependentMixin", ->

    # the only thing this mixin does is add dependencies to an array on the object constructor,
    # which we test by observing the behavior of the Container class, rather than the
    # implementation details of the DependentMixin.