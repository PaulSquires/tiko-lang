'' Calls through interface values (docs/tiko-interfaces §8): a vptr-less type, an abstract
'' implementer reached through a thunk into the override, a base type's mapping inherited,
'' IPet to IAnimal (the primary base: same itable), a byval interface parameter, and '='
'' over references and nullptr.
interface IAnimal
    sub Speak( )
    function Name( ) as string
end interface
interface IPet
    inherits IAnimal
    function Owner( ) as string
end interface
type Rock
    implements IAnimal
    as long w
    declare sub Speak( ) implements IAnimal.Speak
    declare function Name( ) as string implements IAnimal.Name
end type
sub Rock.Speak( )
    print "rock: ..."; w
end sub
function Rock.Name( ) as string
    return "rock"
end function
class Animal
    implements IAnimal
    as string nm
    declare abstract sub Speak( ) implements IAnimal.Speak
    declare virtual function Name( ) as string implements IAnimal.Name
end class
function Animal.Name( ) as string
    return nm
end function
class Dog
    inherits Animal
    implements IPet
    declare sub Speak( ) override
    declare function Owner( ) as string implements IPet.Owner
end class
sub Dog.Speak( )
    print "woof from "; nm
end sub
function Dog.Owner( ) as string
    return "me"
end function
sub Talk( byval a as IAnimal )
    a.Speak( )
    print "  name: "; a.Name( )
end sub
dim as Rock r : r.w = 7
dim as Dog d : d.nm = "Rex"
dim as IAnimal a = @r
Talk( a )
a = d
Talk( a )
dim as IPet p = @d
print p.Owner( ), p.Name( )
Talk( p )
dim as IAnimal n = nullptr
print n = nullptr, a = nullptr, a = p
if a <> nullptr then print "a set"
dim as IAnimal a2 = @d
if a2 = a then print "same object"
