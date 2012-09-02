#= require ./dependent_module

namespace "core"

# Base class for dependent classes.
#
class core.DependentObject extends core.BaseObject
    @include core.DependentModule