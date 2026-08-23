'' A STATIC OR SHARED AGGREGATE IS INITIALISED WHERE IT IS DEFINED, not by stores.
''
'' Measured: 'static as GUID g = type<GUID>( &h00020400, 0, 0, { &hC0, ... } )' is
''
''     static struct $4GUID G$1 = { 132096u, (uint16)0u, (uint16)0u,
''                                  { (uint8)192u, ... (uint8)70u } };
''
'' -- a C static with an initialiser list and NO CODE AT ALL. The field values with
'' their offsets are exactly a byte image of the object, which is what
'' MirGlobal.initBytes has been for since it was added and what nothing filled.
''
'' fb/comptr.bi declares every COM IID this way, so every one of them declined.
''
'' Every leaf must fold or the whole thing declines: a partial image would look
'' initialised in the bytes that folded and zero everywhere else, with nothing to say
'' which was which.
type GUID
    as ulong  d1
    as ushort d2
    as ushort d3
    as ubyte  d4( 0 to 7 )
end type

function IidOf( ) as GUID ptr
    static as GUID g = type<GUID>( &h00020400, &h0000, &h0000, _
                                   { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )
    return @g
end function

'' A SHARED one, and a partial field list -- the unwritten tail is zero, which is what
'' a static's storage is anyway.
type Pair
    as long  a
    as long  b
end type
dim shared as Pair gp = type<Pair>( 7 )

'' FLOATS go in as their BITS, little-endian like everything else.
type Fs
    as single s
    as double d
end type
dim shared as Fs gf = type<Fs>( 1.5, 2.5 )
