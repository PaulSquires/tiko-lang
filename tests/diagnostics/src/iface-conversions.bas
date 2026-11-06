'' docs/tiko-interfaces §5.3: what converts to an interface, and what does not (TKO1009).
'' The legal conversions and calls are refused with TKO0992 until Phase 3 compiles them.
interface IAnimal
    sub Speak( )
end interface
interface IPet
    inherits IAnimal
    function Owner( ) as string
end interface
interface IOther
    sub Z( )
end interface
class Animal
    implements IAnimal
    as long legs
    declare virtual sub Speak( ) implements IAnimal.Speak
end class
class Dog
    inherits Animal
    implements IPet
    declare function Owner( ) as string implements IPet.Owner
end class
sub Over overload ( byval a as IAnimal )
end sub
sub Over overload ( byval a as Animal ptr )
end sub
dim as Dog rex
dim as IPet p = @rex
dim as IAnimal a
a = p
p.Speak( )
Over( @rex )
p = a
dim as IOther o = @rex
dim as Dog ptr d = a
dim as any ptr q
dim as IAnimal f = ( q, q )
