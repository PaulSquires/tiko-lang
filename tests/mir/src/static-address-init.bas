'' 'static px as UDT ptr = @x' -- A STATIC POINTER INITIALISED FROM AN ADDRESS, which
'' had nothing in the IR to express it. A MirGlobal held 'initInt' for a constant and
'' 'initBytes' for a byte image, and the address of another global is NEITHER: it is a
'' RELOCATION, fixed at load time and not computable at compile time. So ConstOf was
'' asked, said no, and every one of these declined. Seven of the thirteen in
'' functions/return-byref.bas are this shape.
''
'' Measured: fbc emits 'static int32* PI$1 = (int32*)&I$1;' -- the initialiser is part
'' of the DEFINITION, not a store somewhere, exactly as an ordinary static's is.
''
'' A PROCEDURE'S ADDRESS IS ITS NAME, not an index: it may be defined in another module,
'' which is the same reason a pointer table's function words are named rather than
'' indexed.
''
'' ONLY WHAT ACTUALLY HAS MODULE STORAGE is taken. '@localVar' is not fixed at load time
'' -- a local has no address until its frame exists -- so the test is the same one
'' GlobalFor itself uses to decide a symbol has a global.
''
'' STILL DECLINING, and recorded rather than guessed at: '@arr( 0 )'. The offset form is
'' written and the shape is recognised, but one of its guards is refusing an array that
'' looks ordinary, and a relocation aimed at the wrong element points the pointer
'' somewhere plausible with nothing to say so.
type U
    as long a
end type

declare function foo( ) as integer

sub s1( )
    static i as integer = 789
    static pi as integer ptr = @i
    static x as U
    static px as U ptr = @x
    static pf as function( ) as integer = @foo
    print *pi, px->a, pf( )
end sub

function foo( ) as integer
    return 1
end function

s1( )
