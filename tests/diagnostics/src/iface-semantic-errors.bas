'' docs/tiko-interfaces §13.2: the semantic diagnostics of declaring and implementing.
interface IAnimal
    sub Speak( )
    function Name( ) as string
end interface
interface IPet
    inherits IAnimal
    function Owner( ) as string
end interface
interface IPrintable
    sub Flush( )
end interface
type NotI
    as long x
end type
interface IBad
    inherits NotI, IPet, IPet
end interface
interface ICyc1
    inherits ICyc0
end interface
interface ICyc0
    inherits ICyc1
end interface

type Bad
    implements IPet
    as long x
    declare function Name( ) as zstring ptr implements IAnimal.Name
    declare sub Speak( byval n as long ) implements IAnimal.Speak
    declare static function Own( ) as string implements IPet.Owner
    declare sub X1( ) implements IPrintable.Flush
    declare sub Y1( ) implements IPet.Nope
    declare function N2( ) as string implements IAnimal.Name
    declare function N3( ) as string implements IAnimal.Name
end type

class BaseA
    implements IAnimal
    declare sub Speak( ) implements IAnimal.Speak
    declare function Name( ) as string implements IAnimal.Name
end class
class Derived
    inherits BaseA
    declare sub Speak2( ) implements IAnimal.Speak
end class
type Twice
    implements IPrintable, IPrintable, NotI
    as long x
    declare sub Flush( ) implements IPrintable.Flush
end type
