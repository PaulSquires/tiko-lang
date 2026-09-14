'' A USTRING FIELD DEFAULT. tracks' VixQuote declares 'as ustring ticker_symbol = "VIX"',
'' and the synthesised constructor assigned it with the NARROW entry point: narrow bytes in
'' a UTF-16 descriptor, so str( ) of it came back as three garbage characters and tracks
'' sent them to TWS as the VIX symbol. A local 'dim as ustring u = "VIX"' was right all
'' along. Measured, fbc-modern prints 'shared len 3 [VIX]', 'local len 3 [VIX]' and
'' 'new len 3 [VIX]' for this source.
type VixQuote
    as ustring ticker_symbol = "VIX"
    as long    ticker_decimals = 2
    as long    ticker_id = -1
end type

dim shared gVix as VixQuote
dim as string a = str( gVix.ticker_symbol )
print "shared len"; len( a ); " [" & a & "]"

scope
    dim as VixQuote l
    dim as string b = str( l.ticker_symbol )
    print "local len"; len( b ); " [" & b & "]"
end scope

dim as VixQuote ptr p = new VixQuote
dim as string d = str( p->ticker_symbol )
print "new len"; len( d ); " [" & d & "]"
delete p
