_global = if window? then window else global

namespace = (scope) ->

  add_namespace = (scope, ctx) ->
    [outer, rest...] = scope
    
    if not ctx[outer]?
      ctx[outer] = {}
    
    if rest.length
      add_namespace rest, ctx[outer]
      
    if ctx == _global and exports?
      exports[outer] = ctx[outer]

  add_namespace scope.split("."), _global
  
_global.namespace = namespace

_global._ = require('underscore')

