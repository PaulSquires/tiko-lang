'' A POINTER ARGUMENT OF ANOTHER KIND is fbc's warning 3, "Passing different pointer types", on
'' lines 30 to 36 (fbc-modern 1.20). Lines 38 to 47 are compatible and draw nothing.
type A
    x as long
end type
type B
    y as long
end type
type D extends A
    z as long
end type
sub TakeA( byval p as A ptr ) : end sub
sub TakeV( byval p as any ptr ) : end sub
sub TakeL( byval p as long ptr ) : end sub
sub TakeZ( byval p as zstring ptr ) : end sub
sub TakePA( byval p as A ptr ptr ) : end sub
sub S1( ) : end sub
sub S2( byval q as long ) : end sub
sub TakeS( byval f as sub( ) ) : end sub
dim as A va
dim as B vb
dim as D vd
dim as any ptr pv
dim as A ptr pa
dim as long n
dim as short s16
dim as ulong u32
dim as byte bt

TakeA( @vb )
TakeL( @s16 )
TakeL( @bt )
TakeL( pa )
TakeZ( @n )
TakeS( procptr( S2 ) )
TakeL( cptr( double ptr, 0 ) )

TakeA( @va )
TakeA( @vd )
TakeA( 0 )
TakeA( pv )
TakeV( @vb )
TakeL( @n )
TakeL( @u32 )
TakeZ( @bt )
TakePA( @pv )
TakeS( procptr( S1 ) )
