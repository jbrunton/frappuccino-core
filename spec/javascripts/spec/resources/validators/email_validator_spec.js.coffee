describe "core.validators.EmailValidator" , ->

    blog_post = validator = valid_addresses = invalid_addresses = {}

    beforeEach ->
        blog_post =
            email: ->
            validation_error: ->

        validator = new core.validators.EmailValidator "email" , null
        spyOn( blog_post, 'validation_error' )


    it "should validate a valid email address",  ->
        spyOn( blog_post, 'email' ).andReturn( "name@domain.com" )
        validator.validate( blog_post )
        expect( blog_post.validation_error ).not.toHaveBeenCalled()

    it "should error an invalid email address abc123",  ->
        spyOn( blog_post, 'email' ).andReturn( "abc123" )
        validator.validate( blog_post )
        expect( blog_post.validation_error ).toHaveBeenCalledWith( "please provide a valid email address" , "email" )    

    it "should error an invalid email address xyz@com",  ->
        spyOn( blog_post, 'email' ).andReturn( "xyz@com" )
        validator.validate( blog_post )
        expect( blog_post.validation_error ).toHaveBeenCalledWith( "please provide a valid email address" , "email" )

    it "should error an invalid email address test.org",  ->
        spyOn( blog_post, 'email' ).andReturn( "test.org" )
        validator.validate( blog_post )
        expect( blog_post.validation_error ).toHaveBeenCalledWith( "please provide a valid email address" , "email" )

    valid_emails = [
        "email@domain.com",                 #   Valid email
        "firstname.lastname@domain.com",    #   Email contains dot in the address field
        "email@subdomain.domain.com",       #   Email contains dot with subdomain
        "firstname+lastname@domain.com",    #   Plus sign is considered valid character
        "email@123.123.123.123",            #   Domain is valid IP address
        #"email@[123.123.123.123]",          #   Square bracket around IP address is considered valid
        #"\"email\"@domain.com",             #   Quotes around email is considered valid
        "1234567890@domain.com",            #   Digits in address are valid
        "email@domain-one.com",             #   Dash in domain name is valid
        "_______@domain.com",               #   Underscore in the address field is valid
        "email@domain.name",                #   .name is valid Top Level Domain name
        "email@domain.co.jp",               #   Dot in Top Level Domain name also considered valid (use co.jp as example here)
        "firstname-lastname@domain.com",     #   Dash in address field is valid
    ]

    invalid_emails = [
        "plainaddress",                 #   Missing @ sign and domain
        "#@%^%#$@#$@#.com",             #   Garbage
        "@domain.com",                  #   Missing username
        "Joe Smith <email@domain.com>", #   Encoded html within email is invalid
        "email.domain.com",             #   Missing @
        "email@domain@domain.com",      #   Two @ sign
        #".email@domain.com",            #   Leading dot in address is not allowed
        #"email.@domain.com",            #   Trailing dot in address is not allowed
        #"email..email@domain.com",      #   Multiple dots
        "あいうえお@domain.com",         #   Unicode char as address
        "email@domain.com (Joe Smith)", #   Text followed email is not allowed
        "email@domain",                 #   Missing top level domain (.com/.net/.org/etc)
        #"email@-domain.com",            #   Leading dash in front of domain is invalid
        #"email@domain.web",             #   .web is not a valid top level domain
        #"email@111.222.333.44444",      #   Invalid IP format
        #"email@domain..com"            #   Multiple dot in the domain portion is invalid
    ]

    create_test_fn = (email_address, expectToBeValid) ->
        -> 
            blog_post =
                email: ->
                    email_address
                validation_error: ->
            spyOn( blog_post, 'validation_error')
            validator.validate( blog_post )
            if expectToBeValid
                expect( blog_post.validation_error ).not.toHaveBeenCalled()
            else
                expect( blog_post.validation_error ).toHaveBeenCalled()

    for email_address in valid_emails
        it "should validate - " + email_address, create_test_fn(email_address, true)

    for email_address in invalid_emails
        it "should error - " + email_address, create_test_fn(email_address, false)

