'' A NON-TRIVIAL UDT RESULT THROUGH A PROCEDURE POINTER. See
'' tests/driver/proc-ptr-sret.test.
''
'' fbc-modern 1.20 compiles this clean and prints:
''
''      43
''     tip 7 for 2
''     tip 9 for 2
''     via param: tip 5 for 2
''      30

'' A 4-byte result with a DESTRUCTOR: non-trivial, so it comes back through a hidden slot.
type Res
    as long v
    declare destructor( )
end type
destructor Res( ) : end destructor

'' A result holding a STRING, as AfxNova's DWSTRING does -- PsTooltip's callback returns one.
type Text
    as string s
end type

type ResFn as function( byval a as any ptr, byval b as any ptr, byval idx as long ) as Res
type TextFn as function( byval hTip as any ptr, byval hAttached as any ptr, byval idx as long ) as Text

type Holder
    as any ptr h1, h2
    as long idx
    res as ResFn
    txt as TextFn
end type

function resImpl( byval a as any ptr, byval b as any ptr, byval idx as long ) as Res
    dim as Res r
    r.v = idx * 10 + iif( a <> 0, 1, 0 ) + iif( b <> 0, 2, 0 )
    return r
end function

function textImpl( byval hTip as any ptr, byval hAttached as any ptr, byval idx as long ) as Text
    dim as Text t
    dim as long n = iif( hTip <> 0, 1, 0 ) + iif( hAttached <> 0, 1, 0 )
    t.s = "tip " & idx & " for " & n
    return t
end function

'' PsTooltip's TIP_ResolveText, reduced: 'return p->callback( p->h1, p->h2, p->idx )'.
function resolveRes( byval p as Holder ptr ) as Res
    return p->res( p->h1, p->h2, p->idx )
end function

function resolveText( byval p as Holder ptr ) as Text
    return p->txt( p->h1, p->h2, p->idx )
end function

function viaParam( byval f as TextFn, byval p as Holder ptr ) as Text
    return f( p->h1, p->h2, 5 )
end function

dim as Holder h
h.h1 = @h : h.h2 = @h : h.idx = 4
h.res = @resImpl
h.txt = @textImpl

print resolveRes( @h ).v
h.idx = 7
print resolveText( @h ).s
dim as TextFn viaVar = @textImpl
print viaVar( @h, @h, 9 ).s
print "via param: "; viaParam( @textImpl, @h ).s
dim as Res direct = h.res( 0, 0, 3 )
print direct.v
