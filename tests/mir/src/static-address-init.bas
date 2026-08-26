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
'' '@arr( n )' IS THE ARRAY'S GLOBAL PLUS A BYTE OFFSET, folded here rather than
'' emitted as arithmetic: a relocation is address-plus-constant and nothing else. The
'' guard that refused it was reading the dimension index as ONE-based -- ArrayBound
'' indexes its pool as 'dim_ * 2', so the first dimension is 0, and asking for 1 walked
'' off the end of a one-dimensional array's pair and answered 'not known'.
''
'' Only the ZERO-BASED spelling is taken: 'dim a(1 to 3)' would need its lower bound
'' subtracted, and getting that wrong points the pointer at the wrong element with
'' nothing to say so, so a non-zero lower bound declines instead.
type U
    as long a
end type

declare function foo( ) as integer

sub s1( )
    static i as integer = 789
    static pi as integer ptr = @i
    static x as U
    static px as U ptr = @x
    static arr(0 to 3) as integer
    static pa as integer ptr = @arr(0)
    static pb as integer ptr = @arr(2)
    static pf as function( ) as integer = @foo
    arr(0) = 10 : arr(2) = 30
    print *pi, px->a, *pa, *pb, pf( )
end sub

function foo( ) as integer
    return 1
end function

s1( )
