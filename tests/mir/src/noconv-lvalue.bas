'' A CONVERSION THAT CONVERTS NOTHING IS AN LVALUE, and only that one. Measured, by
'' asking fbc to accept each:
''
''   dim as integer i : cuint( i ) = i + 1     'I = (uint64)(I + 1)'
''   dim as long j    : clng( j ) = j + 1      'J = (int32)((int64)J + 1)'
''   dim as long i    : cuint( i ) = i + 1     error 24, Invalid data types
''   dim as long j    : @cast( long, j )       accepted
''   dim as longint k : @cast( integer, k )    accepted -- INT and INTPTR are one family
''   dim as long j    : @cast( single, j )     error 24 -- same SIZE, still a conversion
''   dim as boolean b : @cast( byte, b )       error 24 -- BOOL is its own family
''
'' ...and the DEFAULTED tails of the two runtime procedures spelled as plain names:
''
''   width( )        fb_Width( -1, -1 )      width( 80 )   fb_Width( 80, -1 )
''   run( cmd )      fb_Run( &CMD, fb_StrAllocTempDescZEx( "", 0 ) )
''
'' ...and 'wspace( n )' as a term of a WIDE concatenation, which is wide by its NAME
'' because Check computes no type for the call:
''
''   fb_WstrAssign( W, 32, L"a" ) ; fb_WstrSpace( 3 ) ; fb_WstrConcatAssign( ... )
dim as integer i
cuint( i ) = i + 1
dim as long j
clng( j ) = j + 1
dim as long ptr pj = @cast( long, j )
dim as longint k
dim as integer ptr pk = @cast( integer, k )
dim as long w = width( )
dim as long w2 = width( 80 )
dim as string cmd = "x"
dim as long r = run( cmd )
dim as wstring * 32 ws
ws = wstr( "a" ) + wspace( 3 ) + wstr( "b" )
print i, j, pj, pk, w, w2, r, ws
