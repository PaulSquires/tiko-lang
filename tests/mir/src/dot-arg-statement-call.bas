'' A STATEMENT-FORM CALL WHOSE FIRST ARGUMENT BEGINS WITH A DOT, in all four
'' spellings. AfxNova's window procedures write the first of them --
'' '.SendMessageW .GetParent( hwnd ), uMsg, wParam, lParam' -- seven times in
'' CImageCtx alone, and it was the ICE the tiko-editor rung exposed.
''
'' A and C were wrong in DIFFERENT ways, which is why all four are here:
''
''   A  .G4 .G1( p ), q, 3, 4    a FIVE-argument call of a four-argument procedure --
''                              '.G1' went in as a function POINTER and p, q, 3, 4
''                              followed it. Caught by the verifier, printed as garbage.
''   B  .G4 G1( p ), q, 3, 4     always worked
''   C  G4 .G1( p ), q, 3, 4     declined outright: "1 statements not lowered", and the
''                              line printed nothing at all
''   D  .G4( .G1( p ), q, 3, 4 ) always worked
''
'' fbc prints " 700 2 3 4" for every one of them.
declare function G4( byval a as long, byval b as long, byval c as long, byval d as long ) as long
declare function G1( byval a as long ) as long
function G4( byval a as long, byval b as long, byval c as long, byval d as long ) as long
    print a; b; c; d
    return 0
end function
function G1( byval a as long ) as long
    return a * 100
end function
namespace NS
    type T
        as long tag
        declare sub Proc( byval p as long, byval q as long )
    end type
    sub T.Proc( byval p as long, byval q as long )
        print "A stmt dot-callee dot-arg  : ";
        .G4 .G1( p ), q, 3, 4
        print "B stmt dot-callee bare-arg : ";
        .G4 G1( p ), q, 3, 4
        print "C stmt bare-callee dot-arg : ";
        G4 .G1( p ), q, 3, 4
        print "D paren dot-callee dot-arg : ";
        .G4( .G1( p ), q, 3, 4 )
    end sub
end namespace
dim as NS.T t
t.Proc( 7, 2 )

'' THE GUARD, in the same file so that a fix which lets every plain-name base through
'' fails here rather than somewhere else: 'mk.x' over a PARAMETERLESS FUNCTION
'' returning a UDT is a real member access, spelled exactly like the callee-plus-
'' dot-argument above. fbc prints 42 for both lines.
type P
    as long x
end type
function mk( ) as P
    dim as P r : r.x = 42 : return r
end function
sub takes1( byval a as long )
    print "takes1 "; a
end sub
print "direct "; mk.x
takes1 mk.x
