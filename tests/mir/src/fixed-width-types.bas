'' THE FIXED-WIDTH TYPE NAMES are prelude typedefs for FreeBASIC's fixed-width types:
'' int8 byte, uint8 ubyte, int16 short, uint16 ushort, int32 long, uint32 ulong,
'' int64 longint, uint64 ulongint, float32 single, float64 double. fbc has none of
'' them; this file, with the ten names typedef'd by hand, prints under fbc-modern:
''
''      1 1 2 2 4 4 8 8 4 8
''     -1280-327680-21474836480-92233720368547758080
''      0.3333333 0.3333333333333333
''     int64 int32
print sizeof( int8 ); sizeof( uint8 ); sizeof( int16 ); sizeof( uint16 ); _
      sizeof( int32 ); sizeof( uint32 ); sizeof( int64 ); sizeof( uint64 ); _
      sizeof( float32 ); sizeof( float64 )
dim as int8 i8 = 127
dim as uint8 u8 = 255
dim as int16 i16 = 32767
dim as uint16 u16 = 65535
dim as int32 i32 = 2147483647
dim as uint32 u32 = 4294967295
dim as int64 i64 = 9223372036854775807
dim as uint64 u64 = 18446744073709551615ull
i8 += 1 : u8 += 1 : i16 += 1 : u16 += 1 : i32 += 1 : u32 += 1 : i64 += 1 : u64 += 1
print i8; u8; i16; u16; i32; u32; i64; u64
dim as float32 f32 = 1 / 3
dim as float64 f64 = 1 / 3
print f32; f64
'' The same type as the FreeBASIC name, not a new one: an overload on int64 is the
'' overload on longint.
sub Which overload( byval x as longint )
    print "int64";
end sub
sub Which overload( byval x as long )
    print " int32"
end sub
Which( i64 )
Which( i32 )
