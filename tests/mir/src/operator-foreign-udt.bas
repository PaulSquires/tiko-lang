'' A GLOBAL OPERATOR IS NOT REACHED BY USER-CONVERTING BOTH OPERANDS. The pair below
'' is what makes the rule; either line alone would let the wrong reading pass.
''
''   w + wstr( "right" )   fbc uses the BUILTIN through W's cast -- no V constructor
''                        and no V operator+ run, and the trace lines prove it
''   vv + a               fbc TAKES V's operator, converting the W operand into a V
''
'' Measured under fbc-modern. Without the rule, AfxNova's
'' 'operator +( DVARIANT, DVARIANT )' -- which arrives with CWinHttpRequest.inc --
'' captured 'aDwstring + aWstring': both operands were constructed into DVARIANTs and
'' the DVARIANT result was handed to 'DWSTRING.operator let( byref as wstring )' as
'' though the object were a wide pointer. tiko-editor segfaulted before it drew a
'' window.
'' Does fbc reach a GLOBAL operator declared over ANOTHER type by converting both
'' operands into it? V has a constructor from W and from a wstring; W casts to wstring.
type W
    as wstring * 32 buf
    declare constructor( )
    declare constructor( byref s as const wstring )
    declare operator cast( ) byref as const wstring
    declare operator let( byref s as const wstring )
end type
operator W.let( byref s as const wstring )
    buf = s
end operator
constructor W( ) : buf = "" : end constructor
constructor W( byref s as const wstring ) : buf = s : end constructor
operator W.cast( ) byref as const wstring : operator = buf : end operator

type V
    as wstring * 64 buf
    declare constructor( )
    declare constructor( byref w_ as W )
    declare constructor( byval p as wstring ptr )
    declare operator cast( ) byref as const wstring
end type
constructor V( ) : buf = "" : end constructor
constructor V( byref w_ as W ) : buf = w_.buf : end constructor
constructor V( byval p as wstring ptr )
    if p <> 0 then
        buf = *p
    else
        buf = ""
    end if
end constructor
operator V.cast( ) byref as const wstring : operator = buf : end operator

operator + ( byref a as V, byref b as V ) as V
    print "  [V operator+ ran]"
    return V( wstr( a.buf & b.buf ) )
end operator

dim as W a = W( "left-" )
dim as W r
r = a + wstr( "right" )
print "result: "; r
'' ONE operand exactly the operator's type, the other reachable only by a user
'' conversion. Does fbc take it?
dim as V vv = V( wstr( "vee-" ) )
dim as V r2 = vv + a
print "mixed: "; r2
