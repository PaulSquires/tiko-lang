'' The dynamic questions (docs/tiko-interfaces §5.5, §9.2): trycast to an interface (a
'' derived one, a miss, a cross cast) and to a type pointer, 'is' both ways -- through a
'' vptr and through a vptr-less type's class descriptor -- from an interface and from a class
'' pointer, and the casts: cast( J, i ) searches, cast( C ptr, i ) is the object word.
interface IAnimal
    function Name( ) as string
end interface
interface IPet
    inherits IAnimal
    function Owner( ) as string
end interface
interface ISwim
    function Swim( ) as string
end interface
class Animal
    implements IAnimal
    as string nm
    declare virtual function Name( ) as string implements IAnimal.Name
end class
function Animal.Name( ) as string
    return nm
end function
class Dog
    inherits Animal
    implements IPet, ISwim
    declare function Owner( ) as string implements IPet.Owner
    declare function Swim( ) as string implements ISwim.Swim
end class
function Dog.Owner( ) as string
    return "me"
end function
function Dog.Swim( ) as string
    return "paddle"
end function
type Rock
    implements IAnimal
    as long w
    declare function Name( ) as string implements IAnimal.Name
end type
function Rock.Name( ) as string
    return "rock"
end function

dim as Dog d : d.nm = "Rex"
dim as Animal an : an.nm = "Generic"
dim as Rock r
dim as IAnimal a = @d, b = @an, c = @r
dim as IPet p = trycast( IPet, a )
print p <> nullptr, p.Owner( )
p = trycast( IPet, b )
print p = nullptr
dim as ISwim s = trycast( ISwim, a )
print s.Swim( )
print a is IPet, b is IPet, c is IPet, a is ISwim
print a is Dog, b is Dog, a is Animal, c is Rock, c is Dog
dim as Dog ptr dp = trycast( Dog ptr, a )
print dp <> 0, dp->Owner( )
dp = trycast( Dog ptr, b )
print dp = 0
dim as Animal ptr ap = @d
print *ap is IPet, an is IPet
dim as ISwim s2 = trycast( ISwim, ap )
print s2.Swim( )
dim as IPet p3 = cast( IPet, a )
print p3.Owner( )
dim as Dog ptr d2 = cast( Dog ptr, a )
print d2->nm
