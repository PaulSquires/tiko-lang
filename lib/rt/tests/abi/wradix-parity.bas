'' wradix-parity.bas -- HEXW, OCTW and BINW: the wide half of the radix family.
''
'' NEEDS-GEN-LLVM -- reserved names.
''
'' Same thirty forwards as the narrow side, over the shared core in
'' inc/radix-core.bi instantiated at wide width. The two differences the
'' instantiation makes are both asserted here: the result is a plain malloc the
'' caller frees, and FAILURE RETURNS NULL rather than a shared empty descriptor.
''
'' The characters are read as RAW UNITS at a stride of sizeof(wstring), because
'' indexing a wstring ptr yields a wstring expression rather than a number --
'' the trap that produced four separate bugs in the strw batch.

extern "rtlib"
    declare function pHex_b   alias "fb_WstrHex_b"   ( byval n as ubyte ) as wstring ptr
    declare function pHex_s   alias "fb_WstrHex_s"   ( byval n as ushort ) as wstring ptr
    declare function pHex_i   alias "fb_WstrHex_i"   ( byval n as ulong ) as wstring ptr
    declare function pHex_l   alias "fb_WstrHex_l"   ( byval n as ulongint ) as wstring ptr
    declare function pHex_p   alias "fb_WstrHex_p"   ( byval p as any ptr ) as wstring ptr
    declare function pHexEx_b alias "fb_WstrHexEx_b" ( byval n as ubyte, byval d as long ) as wstring ptr
    declare function pHexEx_s alias "fb_WstrHexEx_s" ( byval n as ushort, byval d as long ) as wstring ptr
    declare function pHexEx_i alias "fb_WstrHexEx_i" ( byval n as ulong, byval d as long ) as wstring ptr
    declare function pHexEx_l alias "fb_WstrHexEx_l" ( byval n as ulongint, byval d as long ) as wstring ptr
    declare function pHexEx_p alias "fb_WstrHexEx_p" ( byval p as any ptr, byval d as long ) as wstring ptr
    declare function pOct_b   alias "fb_WstrOct_b"   ( byval n as ubyte ) as wstring ptr
    declare function pOct_s   alias "fb_WstrOct_s"   ( byval n as ushort ) as wstring ptr
    declare function pOct_i   alias "fb_WstrOct_i"   ( byval n as ulong ) as wstring ptr
    declare function pOct_l   alias "fb_WstrOct_l"   ( byval n as ulongint ) as wstring ptr
    declare function pOct_p   alias "fb_WstrOct_p"   ( byval p as any ptr ) as wstring ptr
    declare function pOctEx_b alias "fb_WstrOctEx_b" ( byval n as ubyte, byval d as long ) as wstring ptr
    declare function pOctEx_s alias "fb_WstrOctEx_s" ( byval n as ushort, byval d as long ) as wstring ptr
    declare function pOctEx_i alias "fb_WstrOctEx_i" ( byval n as ulong, byval d as long ) as wstring ptr
    declare function pOctEx_l alias "fb_WstrOctEx_l" ( byval n as ulongint, byval d as long ) as wstring ptr
    declare function pOctEx_p alias "fb_WstrOctEx_p" ( byval p as any ptr, byval d as long ) as wstring ptr
    declare function pBin_b   alias "fb_WstrBin_b"   ( byval n as ubyte ) as wstring ptr
    declare function pBin_s   alias "fb_WstrBin_s"   ( byval n as ushort ) as wstring ptr
    declare function pBin_i   alias "fb_WstrBin_i"   ( byval n as ulong ) as wstring ptr
    declare function pBin_l   alias "fb_WstrBin_l"   ( byval n as ulongint ) as wstring ptr
    declare function pBin_p   alias "fb_WstrBin_p"   ( byval p as any ptr ) as wstring ptr
    declare function pBinEx_b alias "fb_WstrBinEx_b" ( byval n as ubyte, byval d as long ) as wstring ptr
    declare function pBinEx_s alias "fb_WstrBinEx_s" ( byval n as ushort, byval d as long ) as wstring ptr
    declare function pBinEx_i alias "fb_WstrBinEx_i" ( byval n as ulong, byval d as long ) as wstring ptr
    declare function pBinEx_l alias "fb_WstrBinEx_l" ( byval n as ulongint, byval d as long ) as wstring ptr
    declare function pBinEx_p alias "fb_WstrBinEx_p" ( byval p as any ptr, byval d as long ) as wstring ptr
    declare sub      pWDel    alias "fb_WstrDelete"  ( byval s as wstring ptr )
end extern

function wlen_( byval p as wstring ptr ) as integer
    if( p = 0 ) then return -1
    dim as ubyte ptr b = cptr( ubyte ptr, p )
    dim as integer n = 0
    do
        dim as ulongint v = 0
        for k as integer = 0 to sizeof( wstring ) - 1
            v or= cast( ulongint, b[n * sizeof( wstring ) + k] ) shl (k * 8)
        next
        if( v = 0 ) then return n
        n += 1
    loop while( n < 80 )
    return n
end function
sub wshow( byref tag as string, byval p as wstring ptr )
    if( p = 0 ) then print tag; " <NULL>" : exit sub
    dim as ubyte ptr b = cptr( ubyte ptr, p )
    dim as integer n = wlen_( p )
    dim as string o = ""
    for i as integer = 0 to n - 1
        dim as ulongint v = 0
        for k as integer = 0 to sizeof( wstring ) - 1
            v or= cast( ulongint, b[i * sizeof( wstring ) + k] ) shl (k * 8)
        next
        o += chr( cint( v ) )
    next
    print tag; " len="; n; " ["; o; "]"
    pWDel( p )
end sub

'' Both results are freed. Only the VERDICT is printed, so this is usable on
'' values -- addresses -- whose text cannot be compared across two links.
sub wsame( byref tag as string, byval a as wstring ptr, byval b as wstring ptr )
    dim as long eq = 0
    if( (a <> 0) andalso (b <> 0) ) then
        dim as integer n = wlen_( a )
        if( n = wlen_( b ) ) then
            dim as ubyte ptr pa = cptr( ubyte ptr, a )
            dim as ubyte ptr pb = cptr( ubyte ptr, b )
            eq = 1
            for i as integer = 0 to n * sizeof( wstring ) - 1
                if( pa[i] <> pb[i] ) then
                    eq = 0
                    exit for
                end if
            next
        end if
    end if
    print tag; " = _l form: "; eq
    if( a <> 0 ) then pWDel( a )
    if( b <> 0 ) then pWDel( b )
end sub

print "== HEXW =="
wshow( "Hex_b 0     ", pHex_b( 0 ) )
wshow( "Hex_b 255   ", pHex_b( 255 ) )
wshow( "Hex_s 65535 ", pHex_s( 65535 ) )
wshow( "Hex_i max   ", pHex_i( &hFFFFFFFFul ) )
wshow( "Hex_l max   ", pHex_l( &hFFFFFFFFFFFFFFFFull ) )
wshow( "Hex_i 305441741", pHex_i( 305441741 ) )
wshow( "HexEx_b 255,4", pHexEx_b( 255, 4 ) )
wshow( "HexEx_b 255,1", pHexEx_b( 255, 1 ) )
wshow( "HexEx_s 255,8", pHexEx_s( 255, 8 ) )
wshow( "HexEx_i 255,0", pHexEx_i( 255, 0 ) )
wshow( "HexEx_l 255,-3", pHexEx_l( 255, -3 ) )
wshow( "HexEx_l 0,5  ", pHexEx_l( 0, 5 ) )

print "== OCTW =="
wshow( "Oct_b 0     ", pOct_b( 0 ) )
wshow( "Oct_b 255   ", pOct_b( 255 ) )
wshow( "Oct_s 65535 ", pOct_s( 65535 ) )
wshow( "Oct_i max   ", pOct_i( &hFFFFFFFFul ) )
wshow( "Oct_l max   ", pOct_l( &hFFFFFFFFFFFFFFFFull ) )
wshow( "OctEx_b 255,2", pOctEx_b( 255, 2 ) )
wshow( "OctEx_l 8,6  ", pOctEx_l( 8, 6 ) )

print "== BINW =="
wshow( "Bin_b 0     ", pBin_b( 0 ) )
wshow( "Bin_b 255   ", pBin_b( 255 ) )
wshow( "Bin_b 5     ", pBin_b( 5 ) )
wshow( "Bin_s 65535 ", pBin_s( 65535 ) )
wshow( "Bin_i max   ", pBin_i( &hFFFFFFFFul ) )
wshow( "Bin_l max   ", pBin_l( &hFFFFFFFFFFFFFFFFull ) )
wshow( "BinEx_b 5,8 ", pBinEx_b( 5, 8 ) )
wshow( "BinEx_b 255,3", pBinEx_b( 255, 3 ) )

'' THE POINTER FORMS ONCE PRINTED THE LENGTH OF A REAL ADDRESS, which measures
'' where the image loaded and not what the runtime does -- and the claim above
'' this block, that they print the host's natural width, was simply wrong:
'' fb_WstrHex_p STRIPS LEADING ZEROS. Hex_p( @marker ) came out 6 code units
'' under fbc's MinGW link and 10 under the MSVC one. See radix-parity.bas, which
'' carried the identical mistake in the narrow family.
''
'' Constant pointers for the TEXT, and an agreement check against the _l form of
'' the same bits for the forward at an unpredictable address.
dim as any ptr kp = cast( any ptr, &hDEADBEEFull )
dim as any ptr kq = cast( any ptr, &hFFFFFFFFFFFFFFFFull )
wshow( "Hex_p  const", pHex_p( kp ) )
wshow( "Hex_p  wide ", pHex_p( kq ) )
wshow( "HexEx_p 4   ", pHexEx_p( kp, 4 ) )
wshow( "HexEx_p 20  ", pHexEx_p( kp, 20 ) )
wshow( "Oct_p  const", pOct_p( kp ) )
wshow( "Oct_p  wide ", pOct_p( kq ) )
wshow( "OctEx_p 6   ", pOctEx_p( kp, 6 ) )
wshow( "Bin_p  const", pBin_p( kp ) )
wshow( "Bin_p  wide ", pBin_p( kq ) )
wshow( "BinEx_p 9   ", pBinEx_p( kp, 9 ) )

dim as integer marker = 0
dim as any ptr mp = @marker
dim as ulongint mv = cast( ulongint, mp )
wsame( "Hex_p  addr ", pHex_p( mp ), pHex_l( mv ) )
wsame( "HexEx_p addr", pHexEx_p( mp, 4 ), pHexEx_l( mv, 4 ) )
wsame( "Oct_p  addr ", pOct_p( mp ), pOct_l( mv ) )
wsame( "OctEx_p addr", pOctEx_p( mp, 6 ), pOctEx_l( mv, 6 ) )
wsame( "Bin_p  addr ", pBin_p( mp ), pBin_l( mv ) )
wsame( "BinEx_p addr", pBinEx_p( mp, 9 ), pBinEx_l( mv, 9 ) )

'' A NULL pointer has a value that IS reproducible.
wshow( "Hex_p NULL  ", pHex_p( 0 ) )
wshow( "Bin_p NULL  ", pBin_p( 0 ) )
