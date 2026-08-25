'' 'cint<n>( x )' AND 'cuint<n>( x )' -- the SIZED CONVERSION spellings.
dim as integer<8>  a8  = 1
dim as uinteger<16> b16 = 2

dim as long c8  = cint<8>( -1 )
dim as long c16 = cint<16>( -1 )
dim as long c32 = cint<32>( -1 )
dim as longint c64 = cint<64>( -1 )
dim as ulong u8  = cuint<8>( 7 )
dim as ulong u16 = cuint<16>( 7 )
dim as ulong u32 = cuint<32>( 7 )
dim as ulongint u64 = cuint<64>( 7 )

'' ...and a bare 'cint' beside a comparison still parses as it always did.
dim as long n = 1
dim as long cmp = ( n < 3 )

print a8, b16, c8, c16, c32, c64, u8, u16, u32, u64, cmp
