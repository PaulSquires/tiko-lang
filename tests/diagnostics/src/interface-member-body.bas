'' A BODY FOR AN INTERFACE MEMBER, 'sub IGreet.Bye( ) ... end sub' -- an interface member
'' has none (docs/tiko-interfaces, TKO0434). It joined the abstract declaration in silence
'' and was never called.
interface IGreet
    sub Hi( )
    function Bye( ) as long
end interface
sub IGreet.Hi( )                                    '' TKO0434
    print "default hi"
end sub
function IGreet.Bye( ) as long                      '' TKO0434
    return 1
end function
type G
    implements IGreet
    declare sub Hi( ) implements IGreet.Hi
    declare function Bye( ) as long implements IGreet.Bye
    as long z
end type
sub G.Hi( ) : print "hi" : end sub                  '' fine: the implementing type's
function G.Bye( ) as long : return 2 : end function
dim gg as G
dim ig as IGreet = gg
ig.Hi( )
