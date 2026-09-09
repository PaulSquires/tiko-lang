'' WHAT 'threadcall' CAN RUN -- fbc errors 289 ("Expected sub") and 288 ("Unsupported
'' function"). The thread trampoline copies each byval argument, and fbc will not copy an
'' aggregate it cannot pass through one pointer. Every line was measured against fbc.
''
'' BYVAL ONLY. The byref side does not reduce to "contains X" -- a byref UDT holding just
'' an array is refused, the SAME type plus a string or a bitfield field is accepted, and a
'' byref union is refused -- so it is declined here rather than half-modelled. Guessing it
'' refused threads/threadcall.bas, which fbc compiles. The consequence is that
'' 'threadcall f( h )' over a 'byref h as HasArray' is still ACCEPTED here and is fbc's
'' 288 -- an over-acceptance kept on purpose, in preference to a rule that refuses working
'' code. Every line below is one both compilers agree on.
''
'' 'goodPlainUdt( p )' LOWERS SINCE 2026-09-09 -- a byval UDT is fbc's composite
'' descriptor, and 'Plain' is a single-integer type, which COLLAPSES to that field's own
'' code. Measured: 'fb_ThreadCall( &GOODPLAINUDT, 0, 0ll, 1, 8ll, &P$0 )', code 8 and no
'' 12 anywhere. See tests/mir/src/threadcall-byval-udt.bas for the whole rule.
type Plain
    a as integer
end type
type HasArray
    a(0 to 1) as integer
end type
type HasBitfield
    b : 1 as integer
    c : 1 as integer
end type
union IsUnion
    a as integer
    b as single
end union
type HasAnonUnion
    a as integer
    union
        b as integer
        c as single
    end union
end type
type HasMember
    declare static sub member( )
    x as integer
end type
sub HasMember.member( )
end sub
sub goodSub( )
end sub
sub goodCdecl cdecl( )
end sub
sub goodStdcall stdcall( )
end sub
sub goodPlainUdt( byval p as Plain )
end sub
sub goodByref( byref p as Plain )
end sub
sub goodStringParam( byval sx as string )
end sub
function isFunction( ) as integer
    return 0
end function
sub badPascal pascal( )
end sub
sub badArray( byval h as HasArray )
end sub
sub badBitfield( byval h as HasBitfield )
end sub
sub badUnion( byval u as IsUnion )
end sub
sub badAnonUnion( byval h as HasAnonUnion )
end sub
dim p as Plain
dim ha as HasArray
dim hb as HasBitfield
dim iu as IsUnion
dim au as HasAnonUnion
dim hm as HasMember
'' Accepted.
dim t1 as any ptr = threadcall goodSub( )
dim t2 as any ptr = threadcall goodCdecl( )
dim t3 as any ptr = threadcall goodStdcall( )
dim t4 as any ptr = threadcall goodPlainUdt( p )
dim t5 as any ptr = threadcall goodByref( p )
dim t5b as any ptr = threadcall goodStringParam( "x" )
'' Refused: not a sub.
dim t6 as any ptr = threadcall isFunction( )
dim t7 as any ptr = threadcall hm.member( )
'' Refused: the sub is fine but its byval argument cannot cross.
dim t8 as any ptr = threadcall badPascal( )
dim t9 as any ptr = threadcall badArray( ha )
dim t10 as any ptr = threadcall badBitfield( hb )
dim t11 as any ptr = threadcall badUnion( iu )
dim t12 as any ptr = threadcall badAnonUnion( au )
