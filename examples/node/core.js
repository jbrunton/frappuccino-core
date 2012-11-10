(function() {
    var namespace, target,
        __slice = [].slice;
    
    if (typeof window !== "undefined" && window !== null) {
        global = window;
    }

    namespace = function(scope) {
        var add_namespace;
        add_namespace = function(scope, ctx) {
            var outer, rest;
            outer = scope[0], rest = 2 <= scope.length ? __slice.call(scope, 1) : [];
            if (!(ctx[outer] != null)) {
                ctx[outer] = {};
            }
            if (rest.length) {
                return add_namespace(rest, ctx[outer]);
            }
        };
        add_namespace(scope.split("."), global);
    };
    
    global.namespace = namespace;
}).call(this);

(function() {
    namespace("core");
    core.foo = "foo";
}).call(this);

global.test = "test";
console.log(test);

exports.core = core;
