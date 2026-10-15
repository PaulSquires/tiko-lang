'' '#assert' OVER TYPES AND SIZES -- fbc's error 308 on lines 17 to 23 and 33 (fbc-modern 1.20).
'' tiko passed each in silence: Resolve folds plain numbers only. Lines 25 to 31 hold and pass.
'' Line 33's UDT size is judged from the layouts (assertlayout.tiko).
type T
    a as long
    b as long
    c as long
end type
dim as long x, y
dim as long ptr p
dim as T t
dim as const long cx = 1
dim as string s
dim as long arr( 3 )
dim as zstring * 8 z

#assert sizeof( long ) = 8
#assert typeof( x ) = typeof( byte )
#assert typeof( x ) <> typeof( long )
#assert typeof( x ) = typeof( integer )
#assert typeof( p ) = typeof( any ptr )
#assert typeof( x ) = typeof( const long )
#assert typeof( t ) = typeof( long )

#assert sizeof( long ) = 4
#assert typeof( x ) = typeof( y )
#assert typeof( p ) = typeof( long ptr )
#assert typeof( cx ) = typeof( const long )
#assert typeof( t ) = typeof( T )
#assert sizeof( s ) = 24 andalso sizeof( z ) = 8
#assert typeof( arr ) = typeof( long )

#assert sizeof( T ) = 8
