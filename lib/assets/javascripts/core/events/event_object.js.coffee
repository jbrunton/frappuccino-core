#= require ./events_module

namespace "core"

# Base class for AER classes.
#
class core.EventObject extends core.DependentObject
    @include core.EventsModule
