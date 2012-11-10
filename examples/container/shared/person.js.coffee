namespace "shared"

class Person

    constructor: (@firstName, @lastName) ->
    
    fullName: =>
        "#{firstName} #{lastName}"

shared.Person = Person
