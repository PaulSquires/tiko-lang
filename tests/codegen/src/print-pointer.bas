'' PRINT OVER A POINTER. fbc prints one as an unsigned integer of the pointer's own
'' width, and writes the conversion out: 'fb_PrintULongint( 0, (uint64)P$0, 1 )'.
'' Without that conversion the call carries a 'ptr' where its declaration says i64,
'' and clang refuses the WHOLE module -- so this is a codegen test, not a MIR one.
type Outer
    b as integer ptr = 0
end type

declare function F( ) as long

dim as Outer o
print o.b

dim as integer ptr p
print p

dim as any ptr a
print a

dim as function( ) as long fp = @F
print fp

function F( ) as long
    return 0
end function
