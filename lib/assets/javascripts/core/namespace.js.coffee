window.namespace = (scope, fn)->

  add_namespace = (scope, ctx) ->
    [outer, rest...] = scope
    
    if not ctx[outer]?
      ctx[outer] = {}
    
    if rest.length
      add_namespace rest, ctx[outer]
    else
      if not ctx[outer].namespace?
        ctx[outer].namespace = window.namespace
      fn.apply(ctx[outer], [])

  add_namespace scope.split("."), this