'' TKO0810: a forward type -- 'type X as Foo', Foo declared nowhere -- used as an object,
'' fbc's error 71; and a QUALIFIED typedef target, fbc's error 3. The controls at the
'' bottom are accepted by fbc.
type X as Foo
dim as X a1
type H
    v as X
end type
sub DefByref( byref v as X )
end sub
declare sub DeclByval( byval v as X )
declare function DeclResult( ) as X
dim as function( ) as X fp1
type Y as X
dim as Y a2
type Q as NS.Bar

'' Accepted by fbc: behind a pointer, and in a DECLARATION a BYREF parameter or result.
dim as X ptr p1
type HP
    v as X ptr
end type
declare sub DeclByref( byref v as X )
declare sub DeclDefault( v as X )
declare function DeclByrefResult( ) byref as X
dim as function( ) byref as X fp2
dim as sub( as X ) sp1
type YP as X ptr
dim as YP p2
print p1 = 0; p2 = 0
