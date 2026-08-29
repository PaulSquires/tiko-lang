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

'' The pointer forms print the host's natural width. Only the LENGTH is
'' comparable for a real address; a NULL pointer has a reproducible value.
dim as integer marker = 0
dim as wstring ptr wp = pHex_p( @marker )
print "Hex_p  len="; wlen_( wp ) : pWDel( wp )
wp = pHexEx_p( @marker, 4 )
print "HexEx_p 4 len="; wlen_( wp ) : pWDel( wp )
wp = pOct_p( @marker )
print "Oct_p  len>0="; iif( wlen_( wp ) > 0, 1, 0 ) : pWDel( wp )
wp = pOctEx_p( @marker, 6 )
print "OctEx_p 6 len="; wlen_( wp ) : pWDel( wp )
wp = pBin_p( @marker )
print "Bin_p  len="; wlen_( wp ) : pWDel( wp )
wp = pBinEx_p( @marker, 9 )
print "BinEx_p 9 len="; wlen_( wp ) : pWDel( wp )
wshow( "Hex_p NULL  ", pHex_p( 0 ) )
wshow( "Bin_p NULL  ", pBin_p( 0 ) )
