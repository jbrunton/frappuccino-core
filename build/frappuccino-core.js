// Underscore.string
// (c) 2010 Esa-Matti Suuronen <esa-matti aet suuronen dot org>
// Underscore.strings is freely distributable under the terms of the MIT license.
// Documentation: https://github.com/epeli/underscore.string
// Some code is borrowed from MooTools and Alexandru Marasteanu.

// Version 2.0.0

(function(root){
  'use strict';

  // Defining helper functions.

  var nativeTrim = String.prototype.trim;

  var parseNumber = function(source) { return source * 1 || 0; };

  var strRepeat = function(i, m) {
    for (var o = []; m > 0; o[--m] = i) {}
    return o.join('');
  };

  var slice = function(a){
    return Array.prototype.slice.call(a);
  };

  var defaultToWhiteSpace = function(characters){
    if (characters) {
      return _s.escapeRegExp(characters);
    }
    return '\\s';
  };

  var sArgs = function(method){
    return function(){
      var args = slice(arguments);
      for(var i=0; i<args.length; i++)
        args[i] = args[i] == null ? '' : '' + args[i];
      return method.apply(null, args);
    };
  };

  // sprintf() for JavaScript 0.7-beta1
  // http://www.diveintojavascript.com/projects/javascript-sprintf
  //
  // Copyright (c) Alexandru Marasteanu <alexaholic [at) gmail (dot] com>
  // All rights reserved.

  var sprintf = (function() {
    function get_type(variable) {
      return Object.prototype.toString.call(variable).slice(8, -1).toLowerCase();
    }

    var str_repeat = strRepeat;

    var str_format = function() {
      if (!str_format.cache.hasOwnProperty(arguments[0])) {
        str_format.cache[arguments[0]] = str_format.parse(arguments[0]);
      }
      return str_format.format.call(null, str_format.cache[arguments[0]], arguments);
    };

    str_format.format = function(parse_tree, argv) {
      var cursor = 1, tree_length = parse_tree.length, node_type = '', arg, output = [], i, k, match, pad, pad_character, pad_length;
      for (i = 0; i < tree_length; i++) {
        node_type = get_type(parse_tree[i]);
        if (node_type === 'string') {
          output.push(parse_tree[i]);
        }
        else if (node_type === 'array') {
          match = parse_tree[i]; // convenience purposes only
          if (match[2]) { // keyword argument
            arg = argv[cursor];
            for (k = 0; k < match[2].length; k++) {
              if (!arg.hasOwnProperty(match[2][k])) {
                throw(sprintf('[_.sprintf] property "%s" does not exist', match[2][k]));
              }
              arg = arg[match[2][k]];
            }
          } else if (match[1]) { // positional argument (explicit)
            arg = argv[match[1]];
          }
          else { // positional argument (implicit)
            arg = argv[cursor++];
          }

          if (/[^s]/.test(match[8]) && (get_type(arg) != 'number')) {
            throw(sprintf('[_.sprintf] expecting number but found %s', get_type(arg)));
          }
          switch (match[8]) {
            case 'b': arg = arg.toString(2); break;
            case 'c': arg = String.fromCharCode(arg); break;
            case 'd': arg = parseInt(arg, 10); break;
            case 'e': arg = match[7] ? arg.toExponential(match[7]) : arg.toExponential(); break;
            case 'f': arg = match[7] ? parseFloat(arg).toFixed(match[7]) : parseFloat(arg); break;
            case 'o': arg = arg.toString(8); break;
            case 's': arg = ((arg = String(arg)) && match[7] ? arg.substring(0, match[7]) : arg); break;
            case 'u': arg = Math.abs(arg); break;
            case 'x': arg = arg.toString(16); break;
            case 'X': arg = arg.toString(16).toUpperCase(); break;
          }
          arg = (/[def]/.test(match[8]) && match[3] && arg >= 0 ? '+'+ arg : arg);
          pad_character = match[4] ? match[4] == '0' ? '0' : match[4].charAt(1) : ' ';
          pad_length = match[6] - String(arg).length;
          pad = match[6] ? str_repeat(pad_character, pad_length) : '';
          output.push(match[5] ? arg + pad : pad + arg);
        }
      }
      return output.join('');
    };

    str_format.cache = {};

    str_format.parse = function(fmt) {
      var _fmt = fmt, match = [], parse_tree = [], arg_names = 0;
      while (_fmt) {
        if ((match = /^[^\x25]+/.exec(_fmt)) !== null) {
          parse_tree.push(match[0]);
        }
        else if ((match = /^\x25{2}/.exec(_fmt)) !== null) {
          parse_tree.push('%');
        }
        else if ((match = /^\x25(?:([1-9]\d*)\$|\(([^\)]+)\))?(\+)?(0|'[^$])?(-)?(\d+)?(?:\.(\d+))?([b-fosuxX])/.exec(_fmt)) !== null) {
          if (match[2]) {
            arg_names |= 1;
            var field_list = [], replacement_field = match[2], field_match = [];
            if ((field_match = /^([a-z_][a-z_\d]*)/i.exec(replacement_field)) !== null) {
              field_list.push(field_match[1]);
              while ((replacement_field = replacement_field.substring(field_match[0].length)) !== '') {
                if ((field_match = /^\.([a-z_][a-z_\d]*)/i.exec(replacement_field)) !== null) {
                  field_list.push(field_match[1]);
                }
                else if ((field_match = /^\[(\d+)\]/.exec(replacement_field)) !== null) {
                  field_list.push(field_match[1]);
                }
                else {
                  throw('[_.sprintf] huh?');
                }
              }
            }
            else {
              throw('[_.sprintf] huh?');
            }
            match[2] = field_list;
          }
          else {
            arg_names |= 2;
          }
          if (arg_names === 3) {
            throw('[_.sprintf] mixing positional and named placeholders is not (yet) supported');
          }
          parse_tree.push(match);
        }
        else {
          throw('[_.sprintf] huh?');
        }
        _fmt = _fmt.substring(match[0].length);
      }
      return parse_tree;
    };

    return str_format;
  })();



  // Defining underscore.string

  var _s = {
              
    VERSION: '2.0.0',

    isBlank: sArgs(function(str){
      return (/^\s*$/).test(str);
    }),

    stripTags: sArgs(function(str){
      return str.replace(/<\/?[^>]+>/ig, '');
    }),

    capitalize : sArgs(function(str) {
      return str.charAt(0).toUpperCase() + str.substring(1).toLowerCase();
    }),

    chop: sArgs(function(str, step){
      step = parseNumber(step) || str.length;
      var arr = [];
      for (var i = 0; i < str.length;) {
        arr.push(str.slice(i,i + step));
        i = i + step;
      }
      return arr;
    }),

    clean: sArgs(function(str){
      return _s.strip(str.replace(/\s+/g, ' '));
    }),

    count: sArgs(function(str, substr){
      var count = 0, index;
      for (var i=0; i < str.length;) {
        index = str.indexOf(substr, i);
        index >= 0 && count++;
        i = i + (index >= 0 ? index : 0) + substr.length;
      }
      return count;
    }),

    chars: sArgs(function(str) {
      return str.split('');
    }),

    escapeHTML: sArgs(function(str) {
      return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
                            .replace(/"/g, '&quot;').replace(/'/g, "&apos;");
    }),

    unescapeHTML: sArgs(function(str) {
      return str.replace(/&lt;/g, '<').replace(/&gt;/g, '>')
                            .replace(/&quot;/g, '"').replace(/&apos;/g, "'").replace(/&amp;/g, '&');
    }),

    escapeRegExp: sArgs(function(str){
      // From MooTools core 1.2.4
      return str.replace(/([-.*+?^${}()|[\]\/\\])/g, '\\$1');
    }),

    insert: sArgs(function(str, i, substr){
      var arr = str.split('');
      arr.splice(parseNumber(i), 0, substr);
      return arr.join('');
    }),

    include: sArgs(function(str, needle){
      return str.indexOf(needle) !== -1;
    }),

    join: sArgs(function(sep) {
      var args = slice(arguments);
      return args.join(args.shift());
    }),

    lines: sArgs(function(str) {
      return str.split("\n");
    }),

    reverse: sArgs(function(str){
        return Array.prototype.reverse.apply(String(str).split('')).join('');
    }),

    splice: sArgs(function(str, i, howmany, substr){
      var arr = str.split('');
      arr.splice(parseNumber(i), parseNumber(howmany), substr);
      return arr.join('');
    }),

    startsWith: sArgs(function(str, starts){
      return str.length >= starts.length && str.substring(0, starts.length) === starts;
    }),

    endsWith: sArgs(function(str, ends){
      return str.length >= ends.length && str.substring(str.length - ends.length) === ends;
    }),

    succ: sArgs(function(str){
      var arr = str.split('');
      arr.splice(str.length-1, 1, String.fromCharCode(str.charCodeAt(str.length-1) + 1));
      return arr.join('');
    }),

    titleize: sArgs(function(str){
      var arr = str.split(' '),
          word;
      for (var i=0; i < arr.length; i++) {
        word = arr[i].split('');
        if(typeof word[0] !== 'undefined') word[0] = word[0].toUpperCase();
        i+1 === arr.length ? arr[i] = word.join('') : arr[i] = word.join('') + ' ';
      }
      return arr.join('');
    }),

    camelize: sArgs(function(str){
      return _s.trim(str).replace(/(\-|_|\s)+(.)?/g, function(match, separator, chr) {
        return chr ? chr.toUpperCase() : '';
      });
    }),

    underscored: function(str){
      return _s.trim(str).replace(/([a-z\d])([A-Z]+)/g, '$1_$2').replace(/\-|\s+/g, '_').toLowerCase();
    },

    dasherize: function(str){
      return _s.trim(str).replace(/([a-z\d])([A-Z]+)/g, '$1-$2').replace(/^([A-Z]+)/, '-$1').replace(/\_|\s+/g, '-').toLowerCase();
    },

    humanize: function(str){
      return _s.capitalize(this.underscored(str).replace(/_id$/,'').replace(/_/g, ' '));
    },

    trim: sArgs(function(str, characters){
      if (!characters && nativeTrim) {
        return nativeTrim.call(str);
      }
      characters = defaultToWhiteSpace(characters);
      return str.replace(new RegExp('\^[' + characters + ']+|[' + characters + ']+$', 'g'), '');
    }),

    ltrim: sArgs(function(str, characters){
      characters = defaultToWhiteSpace(characters);
      return str.replace(new RegExp('\^[' + characters + ']+', 'g'), '');
    }),

    rtrim: sArgs(function(str, characters){
      characters = defaultToWhiteSpace(characters);
      return str.replace(new RegExp('[' + characters + ']+$', 'g'), '');
    }),

    truncate: sArgs(function(str, length, truncateStr){
      truncateStr = truncateStr || '...';
      length = parseNumber(length);
      return str.length > length ? str.slice(0,length) + truncateStr : str;
    }),

    /**
     * _s.prune: a more elegant version of truncate
     * prune extra chars, never leaving a half-chopped word.
     * @author github.com/sergiokas
     */
    prune: sArgs(function(str, length, pruneStr){
      // Function to check word/digit chars including non-ASCII encodings. 
      var isWordChar = function(c) { return ((c.toUpperCase() != c.toLowerCase()) || /[-_\d]/.test(c)); }
      
      var template = '';
      var pruned = '';
      var i = 0;
      
      // Set default values
      pruneStr = pruneStr || '...';
      length = parseNumber(length);
      
      // Convert to an ASCII string to avoid problems with unicode chars.
      for (i in str) {
        template += (isWordChar(str[i]))?'A':' ';
      } 

      // Check if we're in the middle of a word
      if( template.substring(length-1, length+1).search(/^\w\w$/) === 0 )
        pruned = _s.rtrim(template.slice(0,length).replace(/([\W][\w]*)$/,''));
      else
        pruned = _s.rtrim(template.slice(0,length));

      pruned = pruned.replace(/\W+$/,'');

      return (pruned.length+pruneStr.length>str.length) ? str : str.substring(0, pruned.length)+pruneStr;
    }),

    words: function(str, delimiter) {
      return String(str).split(delimiter || " ");
    },

    pad: sArgs(function(str, length, padStr, type) {
      var padding = '',
          padlen  = 0;

      length = parseNumber(length);

      if (!padStr) { padStr = ' '; }
      else if (padStr.length > 1) { padStr = padStr.charAt(0); }
      switch(type) {
        case 'right':
          padlen = (length - str.length);
          padding = strRepeat(padStr, padlen);
          str = str+padding;
          break;
        case 'both':
          padlen = (length - str.length);
          padding = {
            'left' : strRepeat(padStr, Math.ceil(padlen/2)),
            'right': strRepeat(padStr, Math.floor(padlen/2))
          };
          str = padding.left+str+padding.right;
          break;
        default: // 'left'
          padlen = (length - str.length);
          padding = strRepeat(padStr, padlen);;
          str = padding+str;
        }
      return str;
    }),

    lpad: function(str, length, padStr) {
      return _s.pad(str, length, padStr);
    },

    rpad: function(str, length, padStr) {
      return _s.pad(str, length, padStr, 'right');
    },

    lrpad: function(str, length, padStr) {
      return _s.pad(str, length, padStr, 'both');
    },

    sprintf: sprintf,

    vsprintf: function(fmt, argv){
      argv.unshift(fmt);
      return sprintf.apply(null, argv);
    },

    toNumber: function(str, decimals) {
      var num = parseNumber(parseNumber(str).toFixed(parseNumber(decimals)));
      return (!(num === 0 && (str !== "0" && str !== 0))) ? num : Number.NaN;
    },

    strRight: sArgs(function(sourceStr, sep){
      var pos =  (!sep) ? -1 : sourceStr.indexOf(sep);
      return (pos != -1) ? sourceStr.slice(pos+sep.length, sourceStr.length) : sourceStr;
    }),

    strRightBack: sArgs(function(sourceStr, sep){
      var pos =  (!sep) ? -1 : sourceStr.lastIndexOf(sep);
      return (pos != -1) ? sourceStr.slice(pos+sep.length, sourceStr.length) : sourceStr;
    }),

    strLeft: sArgs(function(sourceStr, sep){
      var pos = (!sep) ? -1 : sourceStr.indexOf(sep);
      return (pos != -1) ? sourceStr.slice(0, pos) : sourceStr;
    }),

    strLeftBack: sArgs(function(sourceStr, sep){
      var pos = sourceStr.lastIndexOf(sep);
      return (pos != -1) ? sourceStr.slice(0, pos) : sourceStr;
    }),

    exports: function() {
      var result = {};

      for (var prop in this) {
        if (!this.hasOwnProperty(prop) || prop == 'include' || prop == 'contains' || prop == 'reverse') continue;
        result[prop] = this[prop];
      }

      return result;
    }

  };

  // Aliases

  _s.strip    = _s.trim;
  _s.lstrip   = _s.ltrim;
  _s.rstrip   = _s.rtrim;
  _s.center   = _s.lrpad;
  _s.ljust    = _s.lpad;
  _s.rjust    = _s.rpad;
  _s.contains = _s.include;

  // CommonJS module is defined
  if (typeof exports !== 'undefined') {
    if (typeof module !== 'undefined' && module.exports) {
      // Export module
      module.exports = _s;
    }
    exports._s = _s;

  // Integrate with Underscore.js
  } else if (typeof root._ !== 'undefined') {
    // root._.mixin(_s);
    root._.string = _s;
    root._.str = root._.string;

  // Or define it
  } else {
    root._ = {
      string: _s,
      str: _s
    };
  }

}(this || window));
(function() {
  var __slice = [].slice;

  window.namespace = function(scope, fn) {
    var add_namespace;
    add_namespace = function(scope, ctx) {
      var outer, rest;
      outer = scope[0], rest = 2 <= scope.length ? __slice.call(scope, 1) : [];
      if (!(ctx[outer] != null)) {
        ctx[outer] = {};
      }
      if (rest.length) {
        return add_namespace(rest, ctx[outer]);
      } else {
        if (!(ctx[outer].namespace != null)) {
          ctx[outer].namespace = window.namespace;
        }
        if (!!(fn != null)) {
          return fn.apply(ctx[outer], []);
        }
      }
    };
    return add_namespace(scope.split("."), this);
  };

}).call(this);
(function() {

  namespace("core.support");

  core.support.Inflector = (function() {

    function Inflector() {
      this._irregulars = {
        singular_forms: {},
        plural_forms: {}
      };
    }

    Inflector.prototype.underscore = function(s) {
      return _.string.underscored(s);
    };

    Inflector.prototype.camelize = function(s) {
      var camel_case;
      camel_case = _.string.camelize(s);
      return _.string.titleize(camel_case.slice(0, 1)).concat(camel_case.slice(1));
    };

    Inflector.prototype.singularize = function(str) {
      var singular;
      singular = this._irregulars.singular_forms[str];
      if (singular == null) {
        singular = core.support.inflections.singularize(str);
      }
      return singular;
    };

    Inflector.prototype.pluralize = function(str) {
      var plural;
      plural = this._irregulars.plural_forms[str];
      if (plural == null) {
        plural = core.support.inflections.pluralize(str);
      }
      return plural;
    };

    Inflector.prototype.classify = function(table_name) {
      return this.camelize(this.singularize(table_name));
    };

    Inflector.prototype.tableize = function(class_name) {
      return this.pluralize(this.underscore(class_name));
    };

    Inflector.prototype.foreign_key = function(class_name) {
      return "" + (this.underscore(class_name)) + "_id";
    };

    Inflector.prototype.inflections = function(callback) {
      var inflector, self;
      self = this;
      inflector = {
        irregular: function(singular, plural) {
          self._irregulars.plural_forms[singular] = plural;
          return self._irregulars.singular_forms[plural] = singular;
        }
      };
      return callback(inflector);
    };

    return Inflector;

  })();

  core.support.inflector = new core.support.Inflector;

}).call(this);
window.core.support.inflections = {};
(function(exports) {

    /**
     * A port of the Rails/ActiveSupport Inflector class
     * http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html
     */
     
    var inflections = exports.inflections = {
        plurals: [],
        singulars: [],
        uncountables: [],
        humans: []
    };
    
    var PLURALS = inflections.plurals,
        SINGULARS = inflections.singulars,
        UNCOUNTABLES = inflections.uncountables,
        HUMANS = inflections.humans;
        
    /**
     * Specifies a new pluralization rule and its replacement. The rule can either 
     * be a string or a regular expression. The replacement should always be a 
     * string that may include references to the matched data from the rule.
     */
    var plural = function (rule, replacement) {
        //inflections.uncountables.delete(rule) if rule.is_a?(String)
        //inflections.uncountables.delete(replacement)
        inflections.plurals.unshift([rule, replacement]);
    }
    
    /**
     * Specifies a new singularization rule and its replacement. The rule can either 
     * be a string or a regular expression. The replacement should always be a 
     * string that may include references to the matched data from the rule.
     */
    var singular = function (rule, replacement) {
        //inflections.uncountables.delete(rule) if rule.is_a?(String)
        //inflections.uncountables.delete(replacement)
        inflections.singulars.unshift([rule, replacement]);
    }
    
    /**
     * Add uncountable words that shouldn't be attempted inflected.
     */
    var uncountable = function (word) {
        inflections.uncountables.unshift(word);
    }
    
    /**
     * Specifies a new irregular that applies to both pluralization and 
     * singularization at the same time. This can only be used for strings, not 
     * regular expressions. You simply pass the irregular in singular and plural 
     * form.
     *
     * Examples:
     *  irregular("octopus", "octopi");
     *  irregular("person", "people");
     */
    var irregular = function (s, p) {
        //inflections.uncountables.delete(singular);
        //inflections.uncountables.delete(plural);
        if (s.substr(0, 1).toUpperCase() == p.substr(0, 1).toUpperCase()) {
            plural(new RegExp("(" + s.substr(0, 1) + ")" + s.substr(1) + "$", "i"), '$1' + p.substr(1));
            plural(new RegExp("(" + p.substr(0, 1) + ")" + p.substr(1) + "$", "i"), '$1' + p.substr(1));
            singular(new RegExp("(" + p.substr(0, 1) + ")" + p.substr(1) + "$", "i"), '$1' + s.substr(1));
        } else {
            plural(new RegExp(s.substr(0, 1).toUpperCase() + s.substr(1) + "$"), p.substr(0, 1).toUpperCase() + p.substr(1));
            plural(new RegExp(s.substr(0, 1).toLowerCase() + s.substr(1) + "$"), p.substr(0, 1).toLowerCase() + p.substr(1));
            plural(new RegExp(p.substr(0, 1).toUpperCase() + p.substr(1) + "$"), p.substr(0, 1).toUpperCase() + p.substr(1));
            plural(new RegExp(p.substr(0, 1).toLowerCase() + p.substr(1) + "$"), p.substr(0, 1).toLowerCase() + p.substr(1));
            singular(new RegExp(p.substr(0, 1).toUpperCase() + p.substr(1) + "$"), s.substr(0, 1).toUpperCase() + s.substr(1));
            singular(new RegExp(p.substr(0, 1).toLowerCase() + p.substr(1) + "$"), s.substr(0, 1).toLowerCase() + s.substr(1));
        }
    }
    
    /**
     * Specifies a humanized form of a string by a regular expression rule or by a 
     * string mapping. When using a regular expression based replacement, the normal 
     * humanize formatting is called after the replacement.
     */
    var human = function (rule, replacement) {
        //inflections.uncountables.delete(rule) if rule.is_a?(String)
        //inflections.uncountables.delete(replacement)
        inflections.humans.push([rule, replacement]);
    }
    
    plural(/$/, "s");
    plural(/s$/i, "s");
    plural(/(ax|test)is$/i, "$1es");
    plural(/(octop|vir)us$/i, "$1i");
    plural(/(alias|status)$/i, "$1es");
    plural(/(bu)s$/i, "$1ses");
    plural(/(buffal|tomat)o$/i, "$1oes");
    plural(/([ti])um$/i, "$1a");
    plural(/sis$/i, "ses");
    plural(/(?:([^f])fe|([lr])f)$/i, "$1$2ves");
    plural(/(hive)$/i, "$1s");
    plural(/([^aeiouy]|qu)y$/i, "$1ies");
    plural(/(x|ch|ss|sh)$/i, "$1es");
    plural(/(matr|vert|ind)(?:ix|ex)$/i, "$1ices");
    plural(/([m|l])ouse$/i, "$1ice");
    plural(/^(ox)$/i, "$1en");
    plural(/(quiz)$/i, "$1zes");
    
    singular(/s$/i, "")
    singular(/(n)ews$/i, "$1ews")
    singular(/([ti])a$/i, "$1um")
    singular(/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$/i, "$1$2sis")
    singular(/(^analy)ses$/i, "$1sis")
    singular(/([^f])ves$/i, "$1fe")
    singular(/(hive)s$/i, "$1")
    singular(/(tive)s$/i, "$1")
    singular(/([lr])ves$/i, "$1f")
    singular(/([^aeiouy]|qu)ies$/i, "$1y")
    singular(/(s)eries$/i, "$1eries")
    singular(/(m)ovies$/i, "$1ovie")
    singular(/(x|ch|ss|sh)es$/i, "$1")
    singular(/([m|l])ice$/i, "$1ouse")
    singular(/(bus)es$/i, "$1")
    singular(/(o)es$/i, "$1")
    singular(/(shoe)s$/i, "$1")
    singular(/(cris|ax|test)es$/i, "$1is")
    singular(/(octop|vir)i$/i, "$1us")
    singular(/(alias|status)es$/i, "$1")
    singular(/^(ox)en/i, "$1")
    singular(/(vert|ind)ices$/i, "$1ex")
    singular(/(matr)ices$/i, "$1ix")
    singular(/(quiz)zes$/i, "$1")
    singular(/(database)s$/i, "$1")
    
    irregular("person", "people");
    irregular("man", "men");
    irregular("child", "children");
    irregular("sex", "sexes");
    irregular("move", "moves");
    irregular("cow", "kine");
    
    uncountable("equipment");
    uncountable("information");
    uncountable("rice");
    uncountable("money");
    uncountable("species");
    uncountable("series");
    uncountable("fish");
    uncountable("sheep");
    uncountable("jeans");
    
    /**
     * Returns the plural form of the word in the string.
     */
    exports.pluralize = function (word) {
        var wlc = word.toLowerCase();
        
        for (var i = 0; i < UNCOUNTABLES.length; i++) {
            var uncountable = UNCOUNTABLES[i];
            if (wlc == uncountable) {
                return word;
            }
        }
        
        for (var i = 0; i < PLURALS.length; i++) {
            var rule = PLURALS[i][0],
                replacement = PLURALS[i][1];        
            if (rule.test(word)) {
                return word.replace(rule, replacement);
            }
        }    
    }
    
    /**
     * Returns the singular form of the word in the string.
     */
    exports.singularize = function (word) {
        var wlc = word.toLowerCase();
        
        for (var i = 0; i < UNCOUNTABLES.length; i++) {
            var uncountable = UNCOUNTABLES[i];
            if (wlc == uncountable) {
                return word;
            }
        }
        
        for (var i = 0; i < SINGULARS.length; i++) {
            var rule = SINGULARS[i][0],
                replacement = SINGULARS[i][1];        
            if (rule.test(word)) {
                return word.replace(rule, replacement);
            }
        }    
    }
    
    /**
     * Capitalizes the first word and turns underscores into spaces and strips a
     * trailing "Key", if any. Like +titleize+, this is meant for creating pretty 
     * output.
     *
     * Examples:
     *   "employeeSalary" => "employee salary"
     *   "authorKey"       => "author"
     */
    exports.humanize = function (word) {
        for (var i = 0; i < HUMANS.length; i++) {
            var rule = HUMANS[i][0],
                replacement = HUMANS[i][1];        
            if (rule.test(word)) {
                word = word.replace(rule, replacement);
            }
        }    
    
        return exports.split(word, " ").toLowerCase();
    }
    
    /**
     * Split a camel case word in its terms.
     */
    exports.split = function (word, delim) {
        delim = delim || " ";
        var replacement = "$1" + delim + "$2";
        return word.
            replace(/([A-Z]+)([A-Z][a-z])/g, replacement).
            replace(/([a-z\d])([A-Z])/g, replacement);
    }
    
    /**
     * Converts a CamelCase word to underscore format.
     */
    exports.underscore = function (word) {
        return exports.split(word, "_").toLowerCase();
    }
    
    /**
     * Converts a CamelCase word to dash (lisp style) format.
     */
    exports.dash = exports.dasherize = function (word) {
        return exports.split(word, "-").toLowerCase();
    }
    
})(window.core.support.inflections);


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
(function() {

  namespace("core");

  core.EventsModule = (function() {

    function EventsModule() {}

    EventsModule.on = function(event, handler) {
      return this.prototype["@" + event] = handler;
    };

    EventsModule.prototype.publish = function(event, args) {
      return this.sandbox.publish(event, args);
    };

    return EventsModule;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespace("core");

  core.EventObject = (function(_super) {

    __extends(EventObject, _super);

    function EventObject() {
      return EventObject.__super__.constructor.apply(this, arguments);
    }

    EventObject.include(core.EventsModule);

    return EventObject;

  })(core.DependentObject);

}).call(this);
(function() {
  var __slice = [].slice;

  namespace("core");

  core.Mediator = (function() {

    function Mediator() {
      this._channels = {};
    }

    Mediator.prototype.subscribe = function(event, handler, context) {
      var _base, _ref;
      if ((_ref = (_base = this._channels)[event]) == null) {
        _base[event] = [];
      }
      return this._channels[event].push(function() {
        return handler.apply(context, arguments);
      });
    };

    Mediator.prototype.publish = function() {
      var args, channels, event, handler, _i, _len, _ref, _results;
      event = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      channels = ((_ref = this._channels) != null ? _ref[event] : void 0) || {};
      _results = [];
      for (_i = 0, _len = channels.length; _i < _len; _i++) {
        handler = channels[_i];
        _results.push(handler.apply(null, args));
      }
      return _results;
    };

    return Mediator;

  })();

}).call(this);
(function() {

  namespace("core.types");

  core.types.ComplexType = (function() {

    function ComplexType(tyName, tyDef, propertyFactory) {
      this.tyName = tyName;
      this.tyDef = tyDef;
      this.propertyFactory = propertyFactory;
      this.kind = "complex";
    }

    ComplexType.prototype.deserializePermissions = function(data, target) {
      var has_permission, permission_name, _ref, _results;
      if ((_ref = target.permissions) == null) {
        target.permissions = {};
      }
      _results = [];
      for (permission_name in data) {
        has_permission = data[permission_name];
        if (target.permissions[permission_name] != null) {
          _results.push(target.permissions[permission_name](has_permission));
        } else {
          _results.push(target.permissions[permission_name] = this.propertyFactory.createProperty(has_permission));
        }
      }
      return _results;
    };

    ComplexType.prototype.serialize = function(obj, env, includeSpec, nested) {
      var data, propName, propTyName, serializeField, tyDef, _ref;
      data = {};
      tyDef = this.tyDef;
      serializeField = function(propName, propDef) {
        var include, prop, propIncludeSpec, propKind, propTy, propTyName, propVal;
        propTyName = propDef.class_name;
        propTy = env.getType(propTyName);
        propKind = propTy.kind;
        if (propDef.primary_key && nested) {
          include = true;
        } else if (includeSpec != null) {
          include = includeSpec[propName] != null;
        } else {
          include = propDef.serialize != null;
        }
        if (include) {
          prop = obj[propName];
          if (!!prop) {
            propVal = prop();
          }
          if (includeSpec != null) {
            propIncludeSpec = includeSpec[propName] || {};
          }
          if (propDef.association) {
            propName = "" + propName + "_attributes";
          }
          return data[propName] = propTy.serialize(propVal, env, propIncludeSpec, true);
        }
      };
      _ref = tyDef.attributes;
      for (propName in _ref) {
        propTyName = _ref[propName];
        serializeField(propName, propTyName);
      }
      if (obj._destroy && obj._destroy()) {
        data._destroy = 1;
      }
      return data;
    };

    ComplexType.prototype.initialize = function(target, env, includeSpec) {
      var initializeField, propName, propTyName, tyDef, _ref;
      tyDef = this.tyDef;
      if (includeSpec == null) {
        includeSpec = {};
      }
      initializeField = function(propName, propDef) {
        var propKind, propTy, propTyName, propVal;
        propTyName = propDef.class_name;
        propTy = env.getType(propTyName);
        propKind = propTy.kind;
        if (includeSpec[propName] != null) {
          if (propKind === "list") {
            return target[propName]([]);
          } else if (propDef.association) {
            propVal = env.create(propTyName);
            target[propName](propVal);
            return propTy.initialize(target[propName](), env, includeSpec[propName]);
          }
        }
      };
      _ref = tyDef.attributes;
      for (propName in _ref) {
        propTyName = _ref[propName];
        initializeField(propName, propTyName);
      }
      return target;
    };

    ComplexType.prototype.deserialize = function(data, env, target) {
      var deserializeField, propName, propTyName, self, tyDef, _ref;
      target = target != null ? target : target = env.create(this.tyName);
      tyDef = this.tyDef;
      self = this;
      if (!(data != null)) {
        return target;
      }
      deserializeField = function(propName, propDef) {
        var prop, propKind, propTy, propTyName, propVal;
        propTyName = propDef.class_name;
        propTy = env.getType(propTyName);
        propKind = propTy.kind;
        propVal = propTy.deserialize(data[propName], env);
        if (target[propName] != null) {
          return target[propName](propVal);
        } else {
          if (propKind === "list") {
            prop = self.propertyFactory.createArrayProperty(propVal);
          } else {
            prop = self.propertyFactory.createProperty(propVal);
          }
          return target[propName] = prop;
        }
      };
      _ref = tyDef.attributes;
      for (propName in _ref) {
        propTyName = _ref[propName];
        deserializeField(propName, propTyName);
      }
      this.deserializePermissions(data.permissions || {
        read: false,
        write: false
      }, target);
      return target;
    };

    return ComplexType;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespace("core.types");

  core.types.Environment = (function(_super) {

    __extends(Environment, _super);

    Environment.dependency({
      propertyFactory: "PropertyFactory"
    });

    Environment.dependency({
      repository: "ModelRepository"
    });

    function Environment() {
      this._types = {};
      this._classes = {};
    }

    Environment.prototype.defineSimpleType = function(tyName, serialize, deserialize) {
      var ty;
      ty = new core.types.SimpleType(tyName, serialize, deserialize);
      this._types[tyName] = ty;
      return ty;
    };

    Environment.prototype.defineComplexType = function(tyName, tyDef, tyClass) {
      var ty;
      ty = new core.types.ComplexType(tyName, tyDef, this.propertyFactory);
      this._types[tyName] = ty;
      this._classes[tyName] = tyClass;
      return ty;
    };

    Environment.prototype.register_model = function(model_class) {
      return this.defineComplexType(model_class.prototype.class_name, model_class.prototype, model_class);
    };

    Environment.prototype.getType = function(tyName) {
      var listElemTyName, match, _;
      match = /^List\[(.*)\]$/.exec(tyName);
      if (match != null) {
        _ = match[0], listElemTyName = match[1];
        return new core.types.ListType(this.getType(listElemTyName), this.propertyFactory);
      } else {
        if (!this._types[tyName]) {
          throw new Error("Type " + tyName + " does not exist in environment");
        }
        return this._types[tyName];
      }
    };

    Environment.prototype.load_collection = function(ty_name, opts) {
      var resource;
      resource = this._classes[ty_name];
      return resource.load_collection(this, opts);
    };

    Environment.prototype.serialize = function(tyName, obj, includeSpec) {
      var ty;
      ty = this.getType(tyName);
      return ty.serialize(obj, this, includeSpec);
    };

    Environment.prototype.deserialize = function(tyName, data, target) {
      var ty;
      ty = this.getType(tyName);
      return ty.deserialize(data, this, target);
    };

    Environment.prototype.initialize = function(tyName, target, includeSpec) {
      var ty;
      ty = this.getType(tyName);
      return ty.initialize(target, this, includeSpec);
    };

    Environment.prototype.create = function(tyName, data) {
      var tyClass;
      tyClass = this._classes[tyName];
      if (tyClass != null) {
        return new tyClass(data, this);
      } else {
        return {};
      }
    };

    /*
        url: ({ res, type, id, action }) ->
            if res?
                for.url( action )
            else
                ty_class = @_classes[type]
                ty_class.url( id, action )
    */


    return Environment;

  })(core.DependentObject);

}).call(this);
(function() {

  namespace("core.types");

  core.types.ListType = (function() {

    function ListType(baseTy) {
      this.baseTy = baseTy;
      this.kind = "list";
    }

    ListType.prototype.serialize = function(list, env, includeSpec, nested) {
      var elem, filtered_list, _i, _len, _results;
      filtered_list = _.reject(list, function(item) {
        return item._destroy && item._destroy() && (item.is_new_record != null) && item.is_new_record();
      });
      if (!_.isUndefined(list)) {
        _results = [];
        for (_i = 0, _len = filtered_list.length; _i < _len; _i++) {
          elem = filtered_list[_i];
          _results.push(this.baseTy.serialize(elem, env, includeSpec, nested));
        }
        return _results;
      }
    };

    ListType.prototype.deserialize = function(array, env) {
      var elem, _i, _len, _results;
      if (!_.isUndefined(array)) {
        _results = [];
        for (_i = 0, _len = array.length; _i < _len; _i++) {
          elem = array[_i];
          _results.push(this.baseTy.deserialize(elem, env));
        }
        return _results;
      }
    };

    return ListType;

  })();

}).call(this);
(function() {

  namespace("core.types");

  core.types.SimplePropertyFactory = (function() {

    function SimplePropertyFactory() {}

    SimplePropertyFactory.prototype.createProperty = function(initVal) {
      var val;
      val = initVal;
      return function() {
        if (arguments.length) {
          return val = arguments[0];
        } else {
          return val;
        }
      };
    };

    SimplePropertyFactory.prototype.createArrayProperty = function(initVal) {
      return this.createProperty(initVal);
    };

    return SimplePropertyFactory;

  })();

  core.types.KoPropertyFactory = (function() {

    function KoPropertyFactory() {}

    KoPropertyFactory.prototype.createProperty = function(initVal) {
      var prop;
      prop = ko.observable(initVal);
      prop.is_valid = ko.observable(true);
      return prop;
    };

    KoPropertyFactory.prototype.createArrayProperty = function(initVal) {
      var prop;
      prop = ko.observableArray(initVal);
      prop.is_valid = ko.observable(true);
      return prop;
    };

    return KoPropertyFactory;

  })();

}).call(this);
(function() {

  this.namespace("core.types");

  core.types.SimpleType = (function() {

    function SimpleType(tyName, serialize, deserialize) {
      this.tyName = tyName;
      this.serialize = serialize;
      this.deserialize = deserialize;
      this.kind = "simple";
      if (!this.serialize) {
        this.serialize = (function(x) {
          return x;
        });
      }
      if (!this.deserialize) {
        this.deserialize = (function(x) {
          return x;
        });
      }
    }

    return SimpleType;

  })();

}).call(this);
(function() {
  var AttributeValidator, ModelValidator, errorsArray;

  namespace("core");

  errorsArray = function() {
    var errors, xs;
    if (typeof ko !== "undefined" && ko !== null) {
      errors = ko.observableArray([]);
    } else {
      xs = [];
      errors = function() {
        if (arguments.length === 0) {
          return xs;
        } else {
          return xs = arguments[0];
        }
      };
      errors.push = function(x) {
        return xs.push(x);
      };
    }
    return errors;
  };

  ModelValidator = (function() {

    function ModelValidator() {
      this.validators = {};
    }

    ModelValidator.prototype.enum_attributes = function() {
      return _.unique(_.flatten(_.map(this.validators, function(validator) {
        return validator.enum_attributes();
      })));
    };

    ModelValidator.prototype.validate = function(model) {
      var attr_name, attr_validator, attribute_name, _i, _len, _ref, _ref1, _results;
      _ref = this.enum_attributes();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attribute_name = _ref[_i];
        model[attribute_name].errors([]);
      }
      _ref1 = this.validators;
      _results = [];
      for (attr_name in _ref1) {
        attr_validator = _ref1[attr_name];
        if (attr_validator.should_validate(model)) {
          _results.push(attr_validator.validate(model));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    ModelValidator.prototype.validate_attribute = function(model, attribute_name) {
      return this.validators[attribute_name].validate(model);
    };

    ModelValidator.prototype.add_attribute_validator = function(validator) {
      return this.validators[validator.attribute_name] = validator;
    };

    ModelValidator.prototype.initialize_model = function(model) {
      var attr_name, attr_validator, _i, _len, _ref, _ref1, _results;
      _ref = this.validators;
      for (attr_name in _ref) {
        attr_validator = _ref[attr_name];
        attr_validator.initialize_model(model);
      }
      _ref1 = this.enum_attributes();
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        attr_name = _ref1[_i];
        _results.push(this.initialize_attribute(model, attr_name));
      }
      return _results;
    };

    ModelValidator.prototype.initialize_attribute = function(model, attribute_name) {
      var errors, is_valid;
      errors = errorsArray();
      model[attribute_name].errors = errors;
      is_valid = (function() {
        return errors().length === 0;
      });
      return model[attribute_name].is_valid = typeof ko !== "undefined" && ko !== null ? ko.computed(is_valid, model) : is_valid;
    };

    return ModelValidator;

  })();

  AttributeValidator = (function() {

    AttributeValidator.prototype.add_validator = function(validator_name, opts) {
      var validator, validator_class_name;
      validator_class_name = "" + (core.support.inflector.camelize(validator_name)) + "Validator";
      validator = new core.validators[validator_class_name](this.attribute_name, opts);
      return this.validators.push(validator);
    };

    AttributeValidator.prototype.parse_opts = function(opts) {
      var validate_if, validate_unless, validators;
      validators = _.clone(opts);
      if (opts["if"] != null) {
        validate_if = opts["if"];
        delete validators["if"];
      }
      if (opts.unless != null) {
        validate_unless = opts.unless;
        delete validators.unless;
      }
      return {
        validate_if: validate_if,
        validate_unless: validate_unless,
        validators: validators
      };
    };

    function AttributeValidator(attribute_name, opts) {
      var validator_name, validator_opts, _ref;
      this.attribute_name = attribute_name;
      opts = this.parse_opts(opts);
      this.validate_if = opts.if_cond;
      this.validate_unless = opts.unless_cond;
      this.validators = [];
      _ref = opts.validators;
      for (validator_name in _ref) {
        validator_opts = _ref[validator_name];
        this.add_validator(validator_name, validator_opts);
      }
    }

    AttributeValidator.prototype.initialize_model = function(model) {
      var validator, _i, _len, _ref, _results;
      _ref = this.validators;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        validator = _ref[_i];
        _results.push(validator.initialize_model(model));
      }
      return _results;
    };

    AttributeValidator.prototype.should_validate = function(model) {
      return (!this.validate_if && !this.valdiate_unless) || (this.validate_if && this.validate_if(model)) || (this.validate_unless && this.validate_unless(model));
    };

    AttributeValidator.prototype.validate = function(model) {
      var validator, _i, _len, _ref, _results;
      _ref = this.validators;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        validator = _ref[_i];
        _results.push(validator.validate(model));
      }
      return _results;
    };

    AttributeValidator.prototype.enum_attributes = function() {
      return _.unique(_.flatten(_.map(this.validators, function(validator) {
        return validator.enum_attributes();
      })));
    };

    return AttributeValidator;

  })();

  core.ValidatesModule = (function() {

    ValidatesModule.validates = function(attribute_name, opts) {
      var attribute_validator, _base, _ref;
      if ((_ref = (_base = this.prototype).model_validator) == null) {
        _base.model_validator = new ModelValidator;
      }
      attribute_validator = new AttributeValidator(attribute_name, opts);
      return this.prototype.model_validator.add_attribute_validator(attribute_validator);
    };

    ValidatesModule.prototype.initialize_validator = function() {
      if (!!(this.model_validator != null)) {
        return this.model_validator.initialize_model(this);
      }
    };

    ValidatesModule.prototype.validation_error = function(message, attribute_name) {
      if (attribute_name != null) {
        return this[attribute_name].errors.push(message);
      } else {
        return this.errors.push(message);
      }
    };

    ValidatesModule.prototype.validate_attribute = function(attribute_name) {
      var _ref;
      if ((_ref = this.model_validator) != null) {
        _ref.validate_attribute(this, attribute_name);
      }
      return this[attribute_name].is_valid();
    };

    ValidatesModule.prototype.validate = function() {
      var _ref;
      if ((_ref = this.model_validator) != null) {
        _ref.validate(this);
      }
      return this.is_valid();
    };

    ValidatesModule.prototype.is_valid = function() {
      var model;
      model = this;
      if (this.model_validator != null) {
        return _.every(this.model_validator.enum_attributes(), function(attr) {
          return model[attr].is_valid();
        });
      } else {
        return true;
      }
    };

    function ValidatesModule() {
      this.errors = new core.ModelErrors;
    }

    return ValidatesModule;

  })();

}).call(this);
(function() {



}).call(this);
(function() {

  namespace("core.resources");

  core.resources.HttpRepository = (function() {

    function HttpRepository() {}

    HttpRepository.prototype.resource_url = function(collection_name, id, includes, action) {
      var query_params, url;
      url = "/api/" + collection_name + "/";
      if (!!(id != null)) {
        url += "" + id + "/";
      }
      if (!!(action != null)) {
        url += "" + action + "/";
      }
      if (includes != null) {
        query_params = this.gen_req_params(includes);
        url = "" + url + "?" + query_params;
      }
      return url;
    };

    HttpRepository.prototype.gen_req_params = function(associations) {
      var build_params;
      build_params = function(associations) {
        var name, value;
        return ((function() {
          var _results;
          _results = [];
          for (name in associations) {
            value = associations[name];
            if (value === true) {
              _results.push(name);
            } else {
              _results.push("" + name + "." + (build_params(value)));
            }
          }
          return _results;
        })()).join(",");
      };
      if (associations != null) {
        return "include=" + (build_params(associations));
      }
    };

    HttpRepository.prototype.get_collection = function(collection_name, opts) {
      var action, error, includes, success, url;
      includes = opts != null ? opts.include : void 0;
      success = opts != null ? opts.success : void 0;
      error = opts != null ? opts.error : void 0;
      action = opts != null ? opts.action : void 0;
      if (opts.url != null) {
        url = opts.url;
      } else {
        url = this.resource_url(collection_name, null, includes, action);
      }
      return $.ajax({
        type: 'GET',
        url: url,
        success: success,
        error: error,
        dataType: 'json'
      });
    };

    HttpRepository.prototype.get_resource = function(collection_name, id, opts) {
      var error, includes, success, url;
      includes = opts != null ? opts.include : void 0;
      success = opts != null ? opts.success : void 0;
      error = opts != null ? opts.error : void 0;
      url = this.resource_url(collection_name, id, includes);
      return $.ajax({
        type: 'GET',
        url: url,
        success: success,
        error: error,
        dataType: 'json'
      });
    };

    HttpRepository.prototype.create_resource = function(collection_name, data, opts) {
      var error, success, url;
      success = opts != null ? opts.success : void 0;
      error = opts != null ? opts.error : void 0;
      url = this.resource_url(collection_name);
      return $.ajax({
        type: 'POST',
        url: url,
        data: {
          data: data
        },
        success: success,
        error: error,
        dataType: 'json'
      });
    };

    HttpRepository.prototype.update_resource = function(collection_name, id, data, opts) {
      var error, success, url;
      success = opts != null ? opts.success : void 0;
      error = opts != null ? opts.error : void 0;
      url = this.resource_url(collection_name, id);
      return $.ajax({
        type: 'PUT',
        url: url,
        data: {
          data: data
        },
        success: success,
        error: error,
        dataType: 'json'
      });
    };

    return HttpRepository;

  })();

}).call(this);
(function() {

  namespace("core.resources");

  core.resources.LocalMemoryRepository = (function() {

    function LocalMemoryRepository() {
      this._collections = {};
      this._sequences = {};
    }

    LocalMemoryRepository.prototype._getCollection = function(collName) {
      if (this._collections[collName] == null) {
        this._collections[collName] = {};
        this._sequences[collName] = 0;
      }
      return this._collections[collName];
    };

    LocalMemoryRepository.prototype._getNextSeq = function(collName) {
      return ++this._sequences[collName];
    };

    LocalMemoryRepository.prototype.get_resource = function(collName, id, _arg) {
      var collection, error, opts, success, _ref;
      _ref = _arg != null ? _arg : {
        success: null,
        error: null,
        opts: null
      }, success = _ref.success, error = _ref.error, opts = _ref.opts;
      collection = this._getCollection(collName);
      return typeof success === "function" ? success(core.util.clone(collection[id])) : void 0;
    };

    LocalMemoryRepository.prototype.createResource = function(collName, data, _arg) {
      var collection, error, opts, success, _ref;
      _ref = _arg != null ? _arg : {
        success: null,
        error: null,
        opts: null
      }, success = _ref.success, error = _ref.error, opts = _ref.opts;
      collection = this._getCollection(collName);
      data.id = this._getNextSeq(collName);
      return typeof success === "function" ? success(collection[data.id] = core.util.clone(data)) : void 0;
    };

    LocalMemoryRepository.prototype.updateResource = function(collName, data, _arg) {
      var collection, error, key, opts, res, success, value, _ref;
      _ref = _arg != null ? _arg : {
        success: null,
        error: null,
        opts: null
      }, success = _ref.success, error = _ref.error, opts = _ref.opts;
      collection = this._getCollection(collName);
      res = collection[data.id];
      for (key in data) {
        value = data[key];
        res[key] = core.util.clone(value);
      }
      return typeof success === "function" ? success(core.util.clone(res)) : void 0;
    };

    return LocalMemoryRepository;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  namespace("core");

  core.Model = (function(_super) {

    __extends(Model, _super);

    Model.include(core.ValidatesModule);

    Model._attribute = function(attribute_name) {
      var _base, _base1, _ref, _ref1;
      if ((_ref = (_base = this.prototype).attributes) == null) {
        _base.attributes = {};
      }
      if ((_ref1 = (_base1 = this.prototype.attributes)[attribute_name]) == null) {
        _base1[attribute_name] = {};
      }
      return this.prototype.attributes[attribute_name];
    };

    Model.attr_serialize = function() {
      var attribute_name, attribute_names, _i, _len, _results;
      attribute_names = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      _results = [];
      for (_i = 0, _len = attribute_names.length; _i < _len; _i++) {
        attribute_name = attribute_names[_i];
        _results.push(this._attribute(attribute_name).serialize = true);
      }
      return _results;
    };

    Model.attr = function(attribute_name, opts) {
      var association, attribute, class_name, primary_key;
      class_name = opts != null ? opts.class_name : void 0;
      if (class_name == null) {
        class_name = "Inherit";
      }
      primary_key = opts != null ? opts.primary_key : void 0;
      if (primary_key == null) {
        primary_key = attribute_name === "id";
      }
      association = opts != null ? opts.association : void 0;
      attribute = this._attribute(attribute_name);
      attribute.class_name = class_name;
      if (!!primary_key) {
        attribute.primary_key = true;
      }
      if (!!association) {
        return attribute.association = true;
      }
    };

    Model.has_many = function(association_name, opts) {
      var class_name;
      class_name = opts != null ? opts.class_name : void 0;
      if (class_name == null) {
        class_name = core.support.inflector.classify(association_name);
      }
      return this.attr(association_name, {
        class_name: "List[" + class_name + "]",
        association: true
      });
    };

    Model.belongs_to = function(association_name, opts) {
      this.has_one(association_name, opts);
      return this.attr(core.support.inflector.foreign_key(association_name));
    };

    Model.has_one = function(association_name, opts) {
      var class_name;
      class_name = opts != null ? opts.class_name : void 0;
      if (class_name == null) {
        class_name = core.support.inflector.camelize(association_name);
      }
      return this.attr(association_name, {
        class_name: class_name,
        association: true
      });
    };

    function Model(data, env) {
      var _ref;
      this.env = env;
      if ((_ref = this.env) == null) {
        this.env = core.Model.default_env;
      }
      this.deserialize(data || {});
      this._destroy = this.env.propertyFactory.createProperty(false);
      this.initialize_validator();
    }

    Model.prototype.is_new_record = function() {
      return !((this.id() != null) && this.id() > 0);
    };

    Model.prototype.serialize = function(opts) {
      return this.env.serialize(this.class_name, this, opts != null ? opts.include : void 0);
    };

    Model.prototype.deserialize = function(data) {
      return this.env.deserialize(this.class_name, data, this);
    };

    Model.prototype.load = function(id, opts) {
      var class_name, collection_name, env, self, success;
      self = this;
      env = this.env;
      class_name = this.class_name;
      collection_name = this.collection_name;
      this.id(id);
      this.env.initialize(class_name, self, opts != null ? opts.include : void 0);
      success = function(data) {
        env.deserialize(class_name, data, self);
        return opts != null ? typeof opts.success === "function" ? opts.success(self) : void 0 : void 0;
      };
      env.repository.get_resource(collection_name, id, _.defaults({
        success: success
      }, opts));
      return this;
    };

    Model.load_collection = function(env, opts) {
      var class_name, collection_name, success;
      class_name = this.prototype.class_name;
      collection_name = this.prototype.collection_name;
      success = function(data) {
        var collection;
        collection = _.map(data, function(el) {
          return env.deserialize(class_name, el);
        });
        return opts != null ? typeof opts.success === "function" ? opts.success(collection) : void 0 : void 0;
      };
      return env.repository.get_collection(collection_name, _.defaults({
        success: success
      }, opts));
    };

    Model.prototype.save = function(opts) {
      var collection_name, env, self, success;
      self = this;
      env = this.env;
      if (opts == null) {
        opts = {};
      }
      collection_name = this.collection_name;
      success = function(data) {
        self.deserialize(data);
        return opts != null ? typeof opts.success === "function" ? opts.success(self) : void 0 : void 0;
      };
      if (this.is_new_record()) {
        return env.repository.create_resource(collection_name, this.serialize(opts), _.defaults({
          success: success
        }, opts));
      } else {
        return env.repository.update_resource(collection_name, this.id(), this.serialize(opts), _.defaults({
          success: success
        }, opts));
      }
    };

    Model.prototype.refresh = function(opts) {
      return this.load(this.id(), opts);
    };

    Model.prototype.destroy = function() {
      return this._destroy(true);
    };

    return Model;

  })(core.BaseObject);

}).call(this);
(function() {

  namespace("core");

  core.ModelErrors = (function() {

    function ModelErrors() {
      this._attributes = [];
      this.count = 0;
    }

    ModelErrors.prototype.add = function(attribute, message) {
      var _ref;
      if ((_ref = this[attribute]) == null) {
        this[attribute] = [];
      }
      this[attribute].push(message);
      if (!_.include(this._attributes, attribute)) {
        this._attributes.push(attribute);
      }
      return this.count += 1;
    };

    ModelErrors.prototype.clear = function() {
      var attribute, _i, _len, _ref;
      _ref = this._attributes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attribute = _ref[_i];
        delete this[attribute];
      }
      this._attributes.length = 0;
      return this.count = 0;
    };

    ModelErrors.prototype.is_valid = function(attribute) {
      return _.include(this._attributes, attribute);
    };

    return ModelErrors;

  })();

}).call(this);
(function() {

  namespace("core.validators");

  core.validators.BaseValidator = (function() {

    function BaseValidator(attribute, opts) {
      this.attribute = attribute;
      this["if"] = opts != null ? opts["if"] : void 0;
      this.unless = opts != null ? opts.unless : void 0;
    }

    BaseValidator.prototype.initialize_model = function(model) {};

    BaseValidator.prototype.attribute_value = function(model, attribute_name) {
      if (attribute_name == null) {
        attribute_name = this.attribute;
      }
      if (model[attribute_name] != null) {
        return model[attribute_name]();
      }
    };

    BaseValidator.prototype.enum_attributes = function() {
      return [this.attribute];
    };

    BaseValidator.prototype.error = function(model, message, attribute_name) {
      if (attribute_name == null) {
        attribute_name = this.attribute;
      }
      return model.validation_error(this.message, attribute_name);
    };

    return BaseValidator;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespace("core.validators");

  core.validators.ConfirmationValidator = (function(_super) {

    __extends(ConfirmationValidator, _super);

    function ConfirmationValidator(attribute, opts) {
      var _ref;
      ConfirmationValidator.__super__.constructor.call(this, attribute, opts);
      this.confirmation_attribute = "" + this.attribute + "_confirmation";
      this.message = opts != null ? opts.message : void 0;
      if ((_ref = this.message) == null) {
        this.message = "values do not match";
      }
    }

    ConfirmationValidator.prototype.initialize_model = function(model) {
      return model[this.confirmation_attribute] = ko.observable();
    };

    ConfirmationValidator.prototype.enum_attributes = function() {
      var attributes;
      attributes = ConfirmationValidator.__super__.enum_attributes.call(this);
      attributes.push(this.confirmation_attribute);
      return attributes;
    };

    ConfirmationValidator.prototype.validate = function(model) {
      var confirmation_input, input;
      input = this.attribute_value(model);
      if (input == null) {
        return;
      }
      confirmation_input = this.attribute_value(model, this.confirmation_attribute);
      if (input !== confirmation_input) {
        return this.error(model, this.message, this.confirmation_attribute);
      }
    };

    return ConfirmationValidator;

  })(core.validators.BaseValidator);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespace("core.validators");

  core.validators.EmailValidator = (function(_super) {

    __extends(EmailValidator, _super);

    function EmailValidator(attribute, opts) {
      var _ref;
      EmailValidator.__super__.constructor.call(this, attribute, opts);
      this.message = opts != null ? opts.message : void 0;
      if ((_ref = this.message) == null) {
        this.message = "please provide a valid email address";
      }
    }

    EmailValidator.prototype.validate = function(model) {
      var input;
      input = this.attribute_value(model);
      if (input == null) {
        return;
      }
      if (!/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/.test(input)) {
        return this.error(model, this.message);
      }
    };

    return EmailValidator;

  })(core.validators.BaseValidator);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespace("core.validators");

  core.validators.FormatValidator = (function(_super) {

    __extends(FormatValidator, _super);

    function FormatValidator(attribute, opts) {
      var _ref;
      FormatValidator.__super__.constructor.call(this, attribute, opts);
      this.format = opts["with"];
      this.message = opts != null ? opts.message : void 0;
      if ((_ref = this.message) == null) {
        this.message = "input must be in the specified format";
      }
    }

    FormatValidator.prototype.validate = function(model) {
      var input;
      input = this.attribute_value(model);
      if (input == null) {
        return;
      }
      if (!this.format.test(input)) {
        return this.error(model, this.message);
      }
    };

    return FormatValidator;

  })(core.validators.BaseValidator);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespace("core.validators");

  core.validators.LengthValidator = (function(_super) {

    __extends(LengthValidator, _super);

    function LengthValidator(attribute, opts) {
      var _ref;
      LengthValidator.__super__.constructor.call(this, attribute, opts);
      this.min = opts.min;
      this.max = opts.max;
      this.message = opts != null ? opts.message : void 0;
      if ((_ref = this.message) == null) {
        this.message = this.default_message();
      }
    }

    LengthValidator.prototype.default_message = function() {
      if (this.min != null) {
        if (this.max != null) {
          return "please enter between " + this.min + " and " + this.max + " characters";
        } else {
          return "please enter at least " + this.min + " characters";
        }
      } else {
        return "please enter at most " + this.max + " characters";
      }
    };

    LengthValidator.prototype.validate = function(model) {
      var input;
      input = this.attribute_value(model);
      if (input == null) {
        return;
      }
      if (((this.min != null) && input.length < this.min) || ((this.max != null) && input.length > this.max)) {
        return this.error(model, this.message);
      }
    };

    return LengthValidator;

  })(core.validators.BaseValidator);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespace("core.validators");

  core.validators.PresenceValidator = (function(_super) {

    __extends(PresenceValidator, _super);

    function PresenceValidator(attribute, opts) {
      var _ref;
      PresenceValidator.__super__.constructor.call(this, attribute, opts);
      this.message = opts != null ? opts.message : void 0;
      if ((_ref = this.message) == null) {
        this.message = this.default_message();
      }
    }

    PresenceValidator.prototype.default_message = function() {
      return "please provide a value for " + this.attribute;
    };

    PresenceValidator.prototype.validate = function(model) {
      var input;
      input = this.attribute_value(model);
      if (!((input != null) && input.length > 0)) {
        return this.error(model, this.message);
      }
    };

    return PresenceValidator;

  })(core.validators.BaseValidator);

}).call(this);
(function() {

  namespace("core");

  core.Renderer = (function() {

    function Renderer() {
      var _base, _ref;
      this.default_bindings = (_ref = (_base = config.renderer).default_bindings) != null ? _ref : _base.default_bindings = {};
    }

    Renderer.prototype.register_template = function(name, content) {
      return this._templates[name] = this._register_template(name, content);
    };

    Renderer.prototype.bind_default_data = function(region_name, data) {
      return this.default_bindings[region_name].data = data;
    };

    Renderer.prototype.region = function(region_name) {
      return $("[data-region='" + region_name + "']");
    };

    Renderer.prototype.regions = function(el) {
      return el.find("[data-region]");
    };

    Renderer.prototype.region_name = function(region) {
      return region.data("region");
    };

    Renderer.prototype.render_region = function(region, bindings) {
      var binding, child, data, region_name, template, _i, _len, _ref, _results;
      region_name = this.region_name(region);
      binding = bindings[region_name];
      template = binding != null ? binding.template : void 0;
      data = binding != null ? binding.data : void 0;
      this.render_template(template, data, region);
      _ref = this.regions(region);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(this.render_region($(child), bindings));
      }
      return _results;
    };

    Renderer.prototype.render_page = function(template, data, bindings) {
      if (bindings == null) {
        bindings = {};
      }
      bindings = _.defaults(bindings, this.default_bindings, {
        content: {
          template: template,
          data: data
        }
      });
      return this.render_region(this.region("master"), bindings);
    };

    return Renderer;

  })();

}).call(this);
(function() {

  namespace("core.util");

  core.util.clone = function(obj) {
    var clone, key;
    if (!(obj != null) || typeof obj !== 'object') {
      return obj;
    }
    if (obj instanceof Date) {
      return new Date(obj.getTime());
    }
    clone = new obj.constructor();
    for (key in obj) {
      clone[key] = core.util.clone(obj[key]);
    }
    return clone;
  };

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespace("core");

  core.Application = (function(_super) {

    __extends(Application, _super);

    Application.dependency({
      renderer: "Renderer"
    });

    Application.dependency({
      router: "Router"
    });

    Application.dependency({
      mediator: "Mediator"
    });

    Application.dependency({
      env: "Environment"
    });

    Application.prototype.helpers = {};

    Application.prototype.modules = {};

    Application.prototype.resolve_module = function(module_name) {
      return this.modules[module_name];
    };

    Application.prototype.resolve_helper = function(helper_name) {
      return this.helpers[helper_name];
    };

    Application.prototype.running = false;

    function Application() {
      this.configure();
    }

    Application.prototype._config = {};

    Application.prototype.config = function(key, value) {
      if (value != null) {
        return this._config[key] = value;
      } else {
        return this._config[key];
      }
    };

    Application.prototype.configure = function() {
      return this.config("app.models", typeof app !== "undefined" && app !== null ? app.models : void 0);
    };

    Application.prototype.register_route = function(url, route_name, controller) {
      return this.router.route(url, name, function() {
        app.request = {
          active_controller: controller
        };
        return controller[route_name].apply(controller, arguments);
      });
    };

    Application.prototype.register_module = function(module) {
      this.modules[module.name] = module;
      return module.sandbox.bind_subscriptions(module);
    };

    Application.prototype.register_controller = function(controller) {
      var content, name, route_name, url, _ref, _ref1, _results;
      this.register_module(controller);
      _ref = controller.routes;
      for (url in _ref) {
        route_name = _ref[url];
        this.register_route(url, route_name, controller);
      }
      _ref1 = controller.templates;
      _results = [];
      for (name in _ref1) {
        content = _ref1[name];
        _results.push(this.renderer.register_template(name, content));
      }
      return _results;
    };

    Application.prototype.register_helper = function(name, helper) {
      this.bind_events(helper);
      return this.helpers[name] = helper;
    };

    Application.prototype.register_model = function(model_name, model_class) {
      model_class.prototype.class_name = model_name;
      model_class.prototype.collection_name = core.support.inflector.tableize(model_name);
      return this.env.register_model(model_class);
    };

    Application.prototype.bind_helper = function(helper_name, target) {
      var helper;
      helper = this.helpers[helper_name];
      if (helper != null) {
        return _.extend(target, helper);
      }
    };

    Application.prototype.bind_events = function(obj) {
      var eventName, handler, regex, _results;
      regex = /^@((\w+)\.)?(\w+)$/;
      _results = [];
      for (eventName in obj) {
        handler = obj[eventName];
        if (eventName[0] === "@") {
          _results.push(this.mediator.subscribe(eventName.slice(1), handler, obj));
        }
      }
      return _results;
    };

    Application.prototype.run = function(bootstrapper) {
      var container;
      container = bootstrapper.configure_container(this);
      container.resolve(this);
      bootstrapper.configure_environment(this.env);
      bootstrapper.register_modules(container);
      bootstrapper.register_helpers(container);
      bootstrapper.register_models();
      this.mediator.publish("Application.initialize");
      this.mediator.publish("Application.ready");
      this.running = true;
      return bootstrapper;
    };

    return Application;

  })(core.DependentObject);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespace("core");

  core.ApplicationModule = (function(_super) {

    __extends(ApplicationModule, _super);

    function ApplicationModule(name) {
      this.name = name;
    }

    ApplicationModule.dependency({
      sandbox: function(container) {
        return container.resolve("Sandbox", [this]);
      }
    });

    ApplicationModule.dependency({
      env: "Environment"
    });

    ApplicationModule.dependency({
      container: function(container) {
        return container.child().register_instance("Sandbox", this.sandbox);
      }
    });

    ApplicationModule.dependency({
      renderer: "Renderer"
    });

    ApplicationModule.dependency({
      router: "Router"
    });

    ApplicationModule.prototype.publish = function() {
      return this.sandbox.publish.apply(sandbox, arguments);
    };

    ApplicationModule.prototype.bind_subscriptions = function(target) {
      this.sandbox.bind_subscriptions.apply(this.sandbox, [target]);
      return target.publish = this.sandbox.publish;
    };

    ApplicationModule.prototype.create_model = function(class_name, opts) {
      return this.env.create(class_name, opts);
    };

    return ApplicationModule;

  })(core.EventObject);

}).call(this);
(function() {

  namespace("core");

  core.Bootstrapper = (function() {

    function Bootstrapper() {}

    Bootstrapper.prototype.configure_container = function(application) {
      var container;
      this.application = application;
      container = new core.Container();
      container.register_instance("Application", this.application);
      container.register_instance("Container", container);
      container.register_class("Sandbox", core.Sandbox);
      container.register_class("Mediator", core.Mediator, {
        singleton: true
      });
      container.register_class("Environment", core.types.Environment, {
        singleton: true
      });
      this.application.mediator = container.resolve("Mediator");
      return container;
    };

    Bootstrapper.prototype.configure_environment = function(env) {
      env.defineSimpleType("Inherit");
      env.defineSimpleType("Number");
      return env.defineSimpleType("String");
    };

    Bootstrapper.prototype.register_modules = function(container) {
      var app_controllers, app_modules, controller, controller_name, controller_regex, klass, klass_name, matches, module, module_name, module_regex, _results;
      app_modules = this.application.config("app.modules");
      if (app_modules == null) {
        app_modules = typeof app !== "undefined" && app !== null ? app.modules : void 0;
      }
      module_regex = /(.*)Module/;
      for (klass_name in app_modules) {
        klass = app_modules[klass_name];
        if (!(matches = module_regex.exec(klass_name))) {
          continue;
        }
        module_name = _.string.underscored(matches[0]);
        module = container.resolve(new klass(module_name));
        this.application.register_module(module);
      }
      app_controllers = this.application.config("app.controllers");
      if (app_controllers == null) {
        app_controllers = typeof app !== "undefined" && app !== null ? app.controllers : void 0;
      }
      controller_regex = /(.*)Controller/;
      _results = [];
      for (klass_name in app_controllers) {
        klass = app_controllers[klass_name];
        if (!(matches = controller_regex.exec(klass_name))) {
          continue;
        }
        controller_name = _.string.underscored(matches[0]);
        controller = container.resolve(new klass(controller_name));
        _results.push(this.application.register_controller(controller));
      }
      return _results;
    };

    Bootstrapper.prototype.register_helpers = function(container) {
      var helper, helper_name, helper_regex, klass, klass_name, matches, _ref, _results;
      helper_regex = /(.*)Helper/;
      _ref = typeof app !== "undefined" && app !== null ? app.helpers : void 0;
      _results = [];
      for (klass_name in _ref) {
        klass = _ref[klass_name];
        if (!(matches = helper_regex.exec(klass_name))) {
          continue;
        }
        helper_name = _.string.underscored(matches[1]);
        helper = container.resolve(new klass());
        _results.push(this.application.register_helper(helper_name, helper));
      }
      return _results;
    };

    Bootstrapper.prototype.register_models = function() {
      var app_models, is_model, model_class, model_name, _results;
      core.Model.default_env = this.application.env;
      is_model = function(model_class) {
        var _ref;
        return ((_ref = model_class.prototype.constructor.__super__) != null ? _ref.constructor : void 0) === core.Model;
      };
      app_models = this.application.config("app.models");
      if (app_models == null) {
        app_models = typeof app !== "undefined" && app !== null ? app.models : void 0;
      }
      _results = [];
      for (model_name in app_models) {
        model_class = app_models[model_name];
        if (is_model(model_class)) {
          _results.push(this.application.register_model(model_name, model_class));
        }
      }
      return _results;
    };

    return Bootstrapper;

  })();

}).call(this);
(function() {



}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  namespace("core");

  core.Sandbox = (function(_super) {

    __extends(Sandbox, _super);

    Sandbox.dependency({
      mediator: "Mediator"
    });

    Sandbox.dependency({
      router: "Router"
    });

    Sandbox.dependency({
      renderer: "Renderer"
    });

    Sandbox.dependency({
      application: "Application"
    });

    function Sandbox(module) {
      this.module = module;
      this.resolve_helper = __bind(this.resolve_helper, this);

      this.resolve_module = __bind(this.resolve_module, this);

      this.bind_subscriptions = __bind(this.bind_subscriptions, this);

      this.publish = __bind(this.publish, this);

      this.scoped_name = __bind(this.scoped_name, this);

    }

    Sandbox.prototype.scoped_name = function(input, opts) {
      var event, regex, scope, _, _ref;
      if ((opts != null ? opts.match_subscriptions : void 0) != null) {
        regex = /^@((\w+)\.)?(\w+)$/;
      } else {
        regex = /^((\w+)\.)?(\w+)$/;
      }
      if (input.match(regex)) {
        _ref = regex.exec(input), _ = _ref[0], _ = _ref[1], scope = _ref[2], event = _ref[3];
        if (scope == null) {
          scope = this.module.name;
        }
        return "" + scope + "." + event;
      } else if ((opts != null ? opts.validate : void 0) != null) {
        throw new Error("Invalid event name: " + input);
      }
    };

    Sandbox.prototype.publish = function() {
      var args, event, scoped_name, _ref;
      event = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      scoped_name = this.scoped_name(event, {
        validate: true
      });
      return (_ref = this.mediator).publish.apply(_ref, [scoped_name].concat(__slice.call(args)));
    };

    Sandbox.prototype.bind_subscriptions = function(obj) {
      var event, handler, scoped_name, _results;
      _results = [];
      for (event in obj) {
        handler = obj[event];
        scoped_name = this.scoped_name(event, {
          match_subscriptions: true
        });
        if (scoped_name != null) {
          _results.push(this.mediator.subscribe(scoped_name, handler, obj));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Sandbox.prototype.resolve_module = function(module_name) {
      return this.application.resolve_module(module_name);
    };

    Sandbox.prototype.resolve_helper = function(helper_name) {
      return this.application.resolve_helper(helper_name);
    };

    return Sandbox;

  })(core.DependentObject);

}).call(this);












