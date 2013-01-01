namespace "core.validators"

class core.validators.NumericalityValidator extends core.validators.BaseValidator

    checkInteger: ( input ) ->
        input % 1 == 0

    checkGreaterThan: ( input, limit ) ->
        input > limit    

    checkGreaterThanOrEqualTo: ( input, limit ) ->
        input >= limit

    checkEqualTo: ( input, limit ) ->
        input == limit

    checkLessThan: ( input, limit ) ->
        input < limit

    checkLessThanOrEqualTo: ( input, limit ) ->
        input <= limit

    checkOdd: ( input ) ->
        input % 2 == 1

    checkEven: ( input ) ->
        input % 2 == 0

    constructor: ( attribute, opts ) ->
        super( attribute, opts )
        @initialize_attributes(opts ,
                            "only_integer",
                            "greater_than",
                            "greater_than_or_equal_to",
                            "equal_to",
                            "less_than",
                            "less_than_or_equal_to",
                            "odd",
                            "even",
                            "message"
                            )
        @message ?= @default_message()
    
    default_message: ->
        message = "Please enter a valid value. Value should be:"
        if (@only_integer==true)
            message += "\nAn integer"
        if (@greater_than?)
            message += "\nGreater than #{@greater_than}"
        if (@greater_than_or_equal_to?)
            message += "\nGreater than or equal to #{@greater_than_or_equal_to}"
        if (@equal_to?)
            message += "\nEqual to #{@equal_to}"
        if (@less_than?)
            message += "\nLess than #{@less_than}"
        if (@less_than_or_equal_to?)
            message += "\nLess than or equal to #{@less_than_or_equal_to}"
        if (@odd==true)
            message += "\nOdd"
        if (@even==true)
            message += "\nEven"
        message
                
    validate: ( model ) ->
        input = @attribute_value( model )
        if (not _.isNumber(input))
            @error( model, @message )    
        if (@only_integer==true and not @checkInteger(input))
            @error( model, @message )
        if (@greater_than? and not @checkGreaterThan(input,@greater_than))
            @error( model, @message )
        if (@greater_than_or_equal_to? and not @checkGreaterThanOrEqualTo(input,@greater_than_or_equal_to))
            @error( model, @message )
        if (@equal_to? and not @checkEqualTo(input,@equal_to))
            @error( model, @message )
        if (@less_than? and not @checkLessThan(input,@less_than))
            @error( model, @message )
        if (@less_than_or_equal_to? and not @checkLessThanOrEqualTo(input,@less_than_or_equal_to))
            @error( model, @message )
        if (@odd==true and not @checkOdd(input))
            @error( model, @message )
        if (@even==true and not @checkEven(input))
            @error( model, @message )