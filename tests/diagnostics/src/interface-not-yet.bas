'' Until docs/tiko-interfaces Phase 2 an interface, and a type's 'implements' line, are
'' parsed and then refused with TKO0992 rather than half-compiled.
interface IShow
    function Show( ) as string
end interface

type Point
    implements IShow
    as long x
    declare function Show( ) as string implements IShow.Show
end type
