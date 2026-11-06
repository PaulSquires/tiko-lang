class Animal
    declare constructor( )
    declare constructor( byref nm as const string )
    declare abstract sub Speak( )
    declare virtual function Name( ) as string
protected:
    as string nm_
end class

class Dog
    inherits Animal
    declare constructor( byref nm as const string )
    declare sub Speak( ) override
end class

type Plain extends object
    as long n
end type

class Sub2
    inherits Plain
    as long m
end class

constructor Animal( )
end constructor
constructor Animal( byref nm as const string )
    nm_ = nm
end constructor
function Animal.Name( ) as string
    return nm_
end function
constructor Dog( byref nm as const string )
    base( nm )
end constructor
sub Dog.Speak( )
    print Name( ) & " says woof"
end sub

dim as Animal ptr a = new Dog( "Rex" )
a->Speak( )
print *a is Dog, sizeof( Dog ), sizeof( Sub2 )
delete a
