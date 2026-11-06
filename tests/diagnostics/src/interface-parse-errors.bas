'' docs/tiko-interfaces §13.2: the parser's diagnostics, one per line.
interface IA
    function F( ) as long
end interface

interface IBad
    as long x
    declare constructor( )
    declare virtual sub V( )
    private:
    sub S( ) override
    function G( ) as long
    inherits IA
end interface

class C1 extends Base
end class

class C2 extern "c"
    as long n
end class

type T1 extends object implements IA
end type

type T2
    inherits IA
    as long n
end type

class C3
    as long n
    implements IA
    declare sub M( ) implements IA
end class

sub Free( ) implements IA.F
end sub
