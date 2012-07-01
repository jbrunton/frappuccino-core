namespace "core", ->

    class @Renderer
    
        constructor: ->
            @default_bindings = config.renderer.default_bindings ?= {}
    
        register_template: (name, content) ->
            @_templates[name] = @_register_template(name, content)
        
        bind_default_data: ( region_name, data ) ->
            @default_bindings[region_name].data = data

        region: ( region_name ) ->
            $( "[data-region='#{region_name}']" )
        
        regions: ( el ) ->
            el.find( "[data-region]" )
            
        region_name: ( region ) ->
            region.data( "region" )
        
        render_region: ( region, bindings ) ->
            region_name = @region_name region
            binding = bindings[region_name]
            
            template = binding?.template
            data = binding?.data
            
            @render_template template, data, region
            
            for child in @regions( region )
                @render_region $( child ), bindings
        
        render_page: ( template, data, bindings = {} ) ->
            # bindings = _.defaults( @bindings, @default_bindings )
            
            bindings = _.defaults( bindings, @default_bindings,
                content: { template: template, data: data } )
            
            @render_region( @region( "master" ), bindings )