'' A NARROW TRIM SET FOR THE WIDE TRIM FAMILY. 'dwsFile = RTRIM( dwsFile, CHR( 32 ) )' (AfxNova's
'' AfxOpenFileDialog) was dropped: the trim set went through the wide-operand reader only, and a
'' narrow 'chr( )' result is not a wide operand. Measured, fbc converts it first --
'' 'fb_WstrRTrimEx( W, fb_StrToWstr( <chr result> ) )' -- and prints '[  ab]', '[ab  ]', '[ab]' and
'' '[host]'. So does tiko. A literal trim set already lowered.
type WS
    as wstring * 16 w
    declare operator cast( ) byref as wstring
end type
operator WS.cast( ) byref as wstring
    return this.w
end operator

dim as wstring * 16 src = "  ab  "
dim as wstring * 16 r
dim as string o
r = rtrim( src, chr( 32 ) )
o = r : print "[" & o & "]"
r = ltrim( src, chr( 32 ) )
o = r : print "[" & o & "]"
r = trim( src, chr( 32 ) )
o = r : print "[" & o & "]"
dim as WS ws1
ws1.w = "host   "
r = rtrim( ws1, chr( 32 ) )          '' a UDT with a wide cast, DWSTRING's shape
o = r : print "[" & o & "]"
