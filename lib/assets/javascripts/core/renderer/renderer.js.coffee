namespace "core"


# Base class for a Renderer.
#
class core.Renderer


    # Instantiates a Renderer, using the config.renderer object for defaults, if available.
    #
    constructor: ->
        @default_bindings = config.renderer.default_bindings ?= {}


    # Registers a template with a given name.
    #
    # @param name [String] the name of the template.
    # @param content [?] the template content (type depends on concrete implementation).
    #
    register_template: (name, content) ->
        @_templates[name] = @_register_template(name, content)


    # Binds default data to a given region.
    #
    # @param region_name [String] the name of the region.
    # @param data [Object] the data to bind.
    #
    bind_default_data: ( region_name, data ) ->
        @default_bindings[region_name].data = data


    # Looks up and returns a region by name.
    #
    # @param region_name [String] the name of the region.
    # @return [Array] the jQuery array of matching elements.
    #
    region: ( region_name ) ->
        $( "[data-region='#{region_name}']" )
    

    # Returns the regions in a given jQuery-wrapped document element.
    # 
    # @param el [Element] the element to search within.
    # @return [Array] a jQuery array of matching elements.
    #
    regions: ( el ) ->
        el.find( "[data-region]" )


    # Returns the name of the given region element.
    #
    # @param region [Element] the region.
    # @return [String] the name of the region.
    #
    region_name: ( region ) ->
        region.data( "region" )


    # Renders a region with the given data/template bindings, then recursively renders any child regions.
    #
    # @param region [Element] the document region to render.
    # @param bindings [Object] an object specifying the binding mappings.
    #
    render_region: ( region, bindings ) ->
        region_name = @region_name region
        binding = bindings[region_name]
        
        template = binding?.template
        data = binding?.data
        
        @render_template template, data, region
        
        for child in @regions( region )
            @render_region $( child ), bindings
    
    
    # Renders a page with the given template and data model.
    #
    # @param template [String] the name of the template to render the 'content' region.
    # @param data [Object] the data model for the 'content' region.
    # @param bindings [Object] any further data bindings (e.g. for other regions).
    #
    render_page: ( template, data, bindings = {} ) ->
        bindings = _.defaults( bindings, @default_bindings,
            content: { template: template, data: data } )
        
        @render_region( @region( "master" ), bindings )