'' operand-consumption.bas -- which entry points RELEASE a temporary operand.
''
'' The class of bug this exists for is invisible until something far away runs
'' out: an entry point that should release a temporary and does not strands one
'' of the 256 pool descriptors per call, and the failure surfaces as a crash in
'' unrelated code once the pool is dry.
''
'' THE SCREENING TOOL: a dependency on fb_hStrDelTemp in fbc's own object.
''
''     nm -u --print-file-name libfb.a | grep ':<member>.o:'
''
'' str_len.o and str_asc.o both list it, and so do str_left.o and str_right.o.
'' strw_trim, strw_comp and strw_len do not -- and measurement agrees.
''
'' Every entry point that takes a string should be checked this way BEFORE it is
'' written. PROBE-27 asked what these four RETURN for every edge, got three
'' contracts right, and still missed this because it never looked at the operand
'' afterwards.
''
'' Captures state into locals before printing: PRINT allocates temporaries, and
'' one of them will reclaim the freed slot before a later check can see it.
#include once "fbc-int/string.bi"
extern "rtlib"
    declare function p_AllocTemp alias "fb_hStrAllocTemp" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
    declare function p_Len   alias "fb_StrLen" ( byval s as any ptr, byval sz as integer ) as integer
    declare function p_Asc   alias "fb_ASC" ( byval s as FBC.FBSTRING ptr, byval i as integer ) as ulong
end extern

function mkTemp( ) as FBC.FBSTRING ptr
    dim as FBC.FBSTRING ptr t = p_AllocTemp( 0, 6 )
    for i as integer = 0 to 5
        t->data[i] = asc("a") + i
    next
    t->data[6] = 0
    return t
end function

dim as FBC.FBSTRING ptr t1 = mkTemp( )
dim as integer n = p_Len( cptr( any ptr, t1 ), -1 )
dim as integer l1 = cint( t1->len and &h7fffffffffffffff ), h1 = iif( t1->data = 0, 0, 1 )

dim as FBC.FBSTRING ptr t2 = mkTemp( )
dim as ulong a = p_Asc( t2, 1 )
dim as integer l2 = cint( t2->len and &h7fffffffffffffff ), h2 = iif( t2->data = 0, 0, 1 )

'' a non-temporary must survive both
dim as string v = "abcdef"
dim as integer n3 = p_Len( cptr( any ptr, @v ), -1 )
dim as ulong a3 = p_Asc( cptr( FBC.FBSTRING ptr, @v ), 1 )
dim as integer l3 = len( v )

print "fb_StrLen(temp,-1) = "; n; "  source after: len="; l1; " held="; h1
print "fb_ASC(temp,1)     = "; a; "  source after: len="; l2; " held="; h2
print "non-temp survives  : len="; l3; " StrLen="; n3; " ASC="; a3
