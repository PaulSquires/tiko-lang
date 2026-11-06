'' 'interface ... end interface', 'inherits'/'implements' lines and method-level
'' 'implements' (docs/tiko-interfaces §4.2-§4.5). Parse only: Phase 2 declares them.
interface IAnimal
    sub Speak( )
    declare function Name( ) as string
    declare const function Legs( ) as long
    function Scale( byval f as double ) as IAnimal
end interface

interface IPet
    inherits IAnimal
    function Owner( ) as string
end interface

interface IAmphibian
    inherits ILandAnimal, IWaterAnimal
    inherits IAnimal
end interface

interface IList( of T )
    sub Add( byref x as T )
end interface

class Dog
    inherits Animal
    implements IPet
    implements IComparable, IShow
    declare sub Speak( ) override
    declare function Owner( ) as string implements IPet.Owner
    declare sub Flush( ) implements ISavable.Flush, IPrintable.Flush
    declare function CompareTo( byval o as IComparable ) as long implements ns.IComparable.CompareTo
end class

type Point
    implements IShow
    as long x, y
    declare function Show( ) as string implements IShow.Show
end type
