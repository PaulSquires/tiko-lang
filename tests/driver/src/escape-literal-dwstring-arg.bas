'' A LITERAL WITH A UNICODE ESCAPE, PASSED TO 'byval as DWSTRING', IS WIDENED WHEN IT GOES TO
'' THE 'wstring ptr' CONSTRUCTOR. Measured on fbc-modern (and fbc 1.10.1), for this file:
''
''     _ZN7AFXNOVA8DWSTRINGC1EPw( &TMP$9556$0, (uint16*)L"\xE8A5\x0000" );
''     ADDS( &TMP$9556$0 );
''
'' fbc prints 'in AddS len= 1 u0=E8A5'. tiko picked the same constructor and passed the NARROW
'' global, whose bytes are the escape's spelling: DWSTRING read '\uE8A5...' as UTF-16 until a
'' zero pair and printed a length between 84 and 92. That is PsToolbar's
'' 'PsToolbar_AddItem( hTB, kind, !"\uE8A5", "New", id )' -- every glyph drew as CJK.
#include once "AfxNova/DWSTRING.inc"
function AddS( byval Glyph as DWSTRING ) as long
    dim as wstring ptr pw = Glyph.vptr
    print "  in AddS len="; len( Glyph ); " u0="; hex( (*pw)[0] )
    return len( Glyph )
end function
print "stmt only:"
AddS( !"\uE8A5" )
