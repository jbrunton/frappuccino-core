(function() {
  var namespace, _global,
    __slice = [].slice;

  _global = typeof window !== "undefined" && window !== null ? window : global;

  namespace = function(scope) {
    var add_namespace;
    add_namespace = function(scope, ctx) {
      var outer, rest;
      outer = scope[0], rest = 2 <= scope.length ? __slice.call(scope, 1) : [];
      if (!(ctx[outer] != null)) {
        ctx[outer] = {};
      }
      if (rest.length) {
        add_namespace(rest, ctx[outer]);
      }
      if (ctx === _global && (typeof exports !== "undefined" && exports !== null)) {
        return exports[outer] = ctx[outer];
      }
    };
    return add_namespace(scope.split("."), _global);
  };

  _global.namespace = namespace;

  _global._ = require('underscore');

}).call(this);
(function() {

  namespace("core");

  core.include = function(target, module) {
    var key, value, _ref, _results;
    for (key in module) {
      value = module[key];
      target[key] = value;
    }
    _ref = module.prototype;
    _results = [];
    for (key in _ref) {
      value = _ref[key];
      _results.push(target.prototype[key] = value);
    }
    return _results;
  };

}).call(this);
(function() {

  namespace("core");

  core.extend = function(target, module) {
    var key, value, _ref, _results;
    _ref = module.prototype;
    _results = [];
    for (key in _ref) {
      value = _ref[key];
      _results.push(target[key] = value);
    }
    return _results;
  };

}).call(this);
(function() {
  var __slice = [].slice;

  namespace("core");

  core.decorate = function() {
    var args, decorator, target;
    target = arguments[0], decorator = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
    core.extend(target, decorator);
    return decorator.apply(target, args);
  };

}).call(this);
(function() {
  var __slice = [].slice;

  namespace("core");

  core.BaseObject = (function() {

    function BaseObject() {}

    BaseObject.include = function(module) {
      return core.include(this, module);
    };

    BaseObject.prototype.decorate = function() {
      return core.decorate.apply(core, [this].concat(__slice.call(arguments)));
    };

    return BaseObject;

  })();

}).call(this);




(function() {

  namespace("core");

  core.Container = (function() {

    function Container(parent) {
      this.parent = parent;
      this._mappings = {};
    }

    Container.prototype._register_mapping = function(name, ref, kind, opts) {
      if (opts == null) {
        opts = {};
      }
      return this._mappings[name] = _.defaults({
        kind: kind,
        ref: ref
      }, opts);
    };

    Container.prototype._resolve_dependencies = function(target, properties) {
      var args, dependency, dependency_args, name;
      for (name in properties) {
        args = properties[name];
        dependency = args[0], dependency_args = args[1];
        if (typeof dependency === "function") {
          target[name] = dependency.apply(target, [this]);
        } else {
          target[name] = this.resolve(dependency, dependency_args);
        }
      }
      return target;
    };

    Container.prototype.register_class = function(name, klass, opts) {
      if (opts == null) {
        opts = {};
      }
      this._register_mapping(name, klass, "class", opts);
      return this;
    };

    Container.prototype.register_instance = function(name, obj) {
      this._register_mapping(name, obj, "instance");
      return this;
    };

    Container.prototype.register_factory = function(name, fn) {
      this._register_mapping(name, fn, "factory");
      return this;
    };

    Container.prototype._resolve_string = function(name, opts) {
      var mapping;
      mapping = this._mappings[name];
      if (mapping == null) {
        return null;
      }
      if (mapping.kind === "instance") {
        return mapping.ref;
      } else if (mapping.kind === "class" && mapping.singleton === true) {
        if (mapping.instance == null) {
          mapping.instance = this.resolve(mapping.ref, opts);
        }
        return mapping.instance;
      } else if (mapping.kind === "factory") {
        return mapping.ref.apply(null, opts);
      } else {
        return this.resolve(mapping.ref, opts);
      }
    };

    Container.prototype._resolve_function = function(fn, opts) {
      var obj;
      if (opts == null) {
        opts = [];
      }
      obj = (function(func, args, ctor) {
        ctor.prototype = func.prototype;
        var child = new ctor, result = func.apply(child, args), t = typeof result;
        return t == "object" || t == "function" ? result || child : child;
      })(fn, opts, function(){});
      return this.resolve(obj);
    };

    Container.prototype._resolve_object = function(target) {
      return this._resolve_dependencies(target, target.dependencies);
    };

    Container.prototype.resolve = function(ref, opts) {
      var resolution;
      if (typeof ref === "string") {
        resolution = this._resolve_string(ref, opts);
      } else if (typeof ref === "function") {
        resolution = this._resolve_function(ref, opts);
      } else if (typeof ref === "object") {
        resolution = this._resolve_object(ref);
      }
      if (resolution != null) {
        return resolution;
      } else if (this.parent != null) {
        if (resolution == null) {
          return this.parent.resolve(ref, opts);
        }
      } else {
        if (resolution == null) {
          throw new Error("Unable to resolve dependency: " + ref);
        }
      }
    };

    Container.prototype.child = function() {
      return new Container(this);
    };

    return Container;

  })();

}).call(this);
(function() {
  var __slice = [].slice;

  namespace("core");

  core.DependentModule = (function() {

    function DependentModule() {}

    DependentModule.dependency = function() {
      var args, dependencies, dependency_name, dependency_type, _base, _ref, _results;
      dependencies = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if ((_ref = (_base = this.prototype).dependencies) == null) {
        _base.dependencies = {};
      }
      _results = [];
      for (dependency_name in dependencies) {
        dependency_type = dependencies[dependency_name];
        _results.push(this.prototype.dependencies[dependency_name] = [dependency_type, args]);
      }
      return _results;
    };

    return DependentModule;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespace("core");

  core.DependentObject = (function(_super) {

    __extends(DependentObject, _super);

    function DependentObject() {
      return DependentObject.__super__.constructor.apply(this, arguments);
    }

    DependentObject.include(core.DependentModule);

    return DependentObject;

  })(core.BaseObject);

}).call(this);



