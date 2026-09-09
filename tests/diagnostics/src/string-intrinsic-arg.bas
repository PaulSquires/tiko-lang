'' A STRING INTRINSIC GIVEN SOMETHING THAT IS NOT A STRING -- fbc's error 58, "Type
'' mismatch", or 99 for the overloaded ones. Measured: a number, a 'wstring ptr' and a
'' 'zstring ptr' are all refused; a POINTER to one is not a string, it needs a deref.
''
'' Declining rather than reporting is what the intrinsic table did for every one of
'' these, so the call came out untyped and the ENCLOSING statement declined instead --
'' silently, with nothing to say why.
''
'' 'instr' IS NOT CHECKED. It has a three-argument form whose first argument is a START
'' POSITION -- 'instr( i + 1, s, sub_ )' -- so a non-string in slot zero is ordinary
'' there, and reporting it refused three files fbc accepts.
''
'' AND IT NOW LOWERS. This golden used to record the three-argument call DECLINING: the
'' acceptance test read slot zero whatever the form, so the call was untyped and PRINT
'' had nothing to classify. The text is slot ONE for that form and the type is INTEGER;
'' the line below is a working fb_StrInstr now, and the decline count in this file went
'' 7 -> 6 for that reason alone.
dim shared as string s
dim shared as wstring ptr w
dim shared as zstring ptr z
dim shared as integer n

'' -- refused ------------------------------------------------------------------
sub refused( )
    print lcase( 0 )
    print ucase( w )
    print left( z, 1 )
    print right( 0, 1 )
    print val( 0 )
    print valint( n )
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    print lcase( s )
    print ucase( s )
    print left( s, 1 )
    print val( s )
    print valint( s )
    print lcase( *z )
    print instr( n + 1, s, "a" )
end sub
