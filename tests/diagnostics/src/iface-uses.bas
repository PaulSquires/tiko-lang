'' docs/tiko-interfaces §5.5, §7.8, §13.2: trycast, 'is', comparisons, nullptr, 'new',
'' 'delete', temporaries, ambiguity, a type-qualified call, a foreign declaration and
'' differing defaults. What is legal is refused with TKO0992 until Phases 3 and 4.
interface IAnimal
    sub Speak( byval times as long = 1 )
end interface
interface IPet
    inherits IAnimal
    function Owner( ) as string
end interface
interface IA
    sub Go( )
end interface
interface IB
    sub Go( )
end interface
interface IC
    inherits IA, IB
end interface
class Animal
    implements IAnimal
    as long legs
    declare virtual sub Speak( byval times as long = 2 ) implements IAnimal.Speak
end class
class Dog
    inherits Animal
    implements IPet
    declare function Owner( ) as string implements IPet.Owner
end class
type Plain
    implements IAnimal
    as long n
    declare sub Speak( byval times as long = 1 ) implements IAnimal.Speak
end type
function MakeDog( ) as Dog
    dim as Dog d
    return d
end function
extern "C"
    declare sub Foreign( byval a as IAnimal )
end extern

dim as Dog rex
dim as Plain pl
dim as IAnimal a = nullptr
dim as IC ic
dim as IPet p2 = trycast( IPet, a )
dim as IAnimal c2 = trycast( IAnimal, @pl )
dim as long n = trycast( long, a )
print a is Dog, rex is IAnimal
if a = nullptr then print 1
if a = 0 then print 2
dim as IAnimal t = MakeDog( )
dim as IAnimal ptr pa = new IAnimal
delete pa
ic.Go( )
IAnimal.Speak( )
