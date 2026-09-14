'' A WIDE value assigned to, and appended to, a UDT with AfxNova DWSTRING's overload set:
'' 'let' over 'byref as wstring', 'byval as wstring ptr', 'byref as string', itself, a
'' longint and a double, and '+=' over the same minus the reference. PsPopupMenu's glyph
'' fields, PsToolbar's overflow captions and PsChart's tooltip percentages.
type WL
    as wstring * 64 buf
    as zstring * 8 how
    declare constructor( )
    declare operator let( byref s as wstring )
    declare operator let( byval p as wstring ptr )
    declare operator let( byref a as string )
    declare operator let( byref o as WL )
    declare operator let( byval n as longint )
    declare operator let( byval d as double )
    declare operator +=( byval p as wstring ptr )
    declare operator +=( byref a as string )
    declare operator +=( byref o as WL )
    declare operator +=( byval n as longint )
    declare operator +=( byval d as double )
end type

constructor WL( )
    how = "default"
end constructor
operator WL.let( byref s as wstring )
    buf = s : how = "let-wr"
end operator
operator WL.let( byval p as wstring ptr )
    buf = *p : how = "let-wp"
end operator
operator WL.let( byref a as string )
    buf = a : how = "let-s"
end operator
operator WL.let( byref o as WL )
    buf = o.buf : how = "let-o"
end operator
operator WL.let( byval n as longint )
    buf = wstr( n ) : how = "let-n"
end operator
operator WL.let( byval d as double )
    buf = wstr( d ) : how = "let-d"
end operator
operator WL.+=( byval p as wstring ptr )
    buf &= *p : how = "cat-wp"
end operator
operator WL.+=( byref a as string )
    buf &= a : how = "cat-s"
end operator
operator WL.+=( byref o as WL )
    buf &= o.buf : how = "cat-o"
end operator
operator WL.+=( byval n as longint )
    buf &= wstr( n ) : how = "cat-n"
end operator
operator WL.+=( byval d as double )
    buf &= wstr( d ) : how = "cat-d"
end operator

type Holder
    as WL glyph
end type

dim as Holder ptr h = new Holder
h->glyph = wchr( &h2713 )
print "field "; h->glyph.how; len( h->glyph.buf ); asc( h->glyph.buf )
dim as WL cap
dim as long i = 4
if len( cap.buf ) = 0 then cap = "#" + wstr( i + 1 )
print "cap "; cap.how; " "; cap.buf
dim as WL v
v = "12"
dim as double total = 3
if total > 0.0 then v += " (" & wstr( clng( int( 1 / total * 100.0 + 0.5 ) ) ) & "%)"
print "v "; v.how; " "; v.buf
delete h
