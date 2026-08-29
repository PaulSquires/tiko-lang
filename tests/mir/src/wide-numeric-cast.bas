'' A NUMERIC CAST OVER A WIDE STRING. fbc parses the text through five entry points
'' taking a bare uint16*, chosen by the RESULT's width and signedness -- the same five
'' 'valint( w )' already used, and the wide twins of the narrow rows beside them:
''
''     cbyte/cshort/clng      fb_WstrValInt      cubyte/cushort/culng   ...UInt
''     cint/clngint           fb_WstrValLng      cuint/culngint         ...ULng
''     csng/cdbl              fb_WstrVal
''
'' Without them the wide argument fell through to the ordinary coercion and the STRING
'' WAS READ AS A NUMBER: a bare 'sitofp' over a variable's buffer, and a 'bitcast' of a
'' literal's ADDRESS. Both verified clean and both answered with a pointer.
sub FromVariable()
    dim as wstring * 8 v = wstr( "789" )
    print cbyte( v ); cubyte( v ); cshort( v ); cushort( v )
    print cint( v ); cuint( v ); clng( v ); culng( v )
    print clngint( v ); culngint( v )
    print csng( v ); cdbl( v )
end sub

'' A LITERAL has no descriptor to load, which is the spelling that bitcast its address.
sub FromLiteral()
    print cdbl( wstr( "789" ) ); clngint( wstr( "456" ) )
end sub

FromVariable()
FromLiteral()
