namespace "core.support"

class core.support.Inflector

    constructor: ->
        @_irregulars =
            singular_forms: {}
            plural_forms: {}

    underscore: ( s ) ->
        _.string.underscored( s )
    
    camelize: ( s ) ->
        camel_case = _.string.camelize( s )
        _.string.titleize( camel_case[0..0] ).concat( camel_case[1..] )
    
    singularize: ( str ) ->
        singular = @_irregulars.singular_forms[str]
        singular = core.support.inflections.singularize( str ) unless singular?
        singular
    
    pluralize: ( str ) ->
        plural = @_irregulars.plural_forms[str]
        plural = core.support.inflections.pluralize( str ) unless plural?
        plural
    
    classify: ( table_name ) ->
        @camelize( @singularize( table_name ) )
        
    
    tableize: ( class_name ) ->
        @pluralize( @underscore( class_name ) )
        
    foreign_key: ( class_name ) ->
        "#{@underscore( class_name )}_id"
    
    inflections: ( callback ) ->
        self = @
        inflector =
            irregular: ( singular, plural ) ->
                self._irregulars.plural_forms[singular] = plural
                self._irregulars.singular_forms[plural] = singular
    
        callback( inflector )
        
core.support.inflector = new core.support.Inflector