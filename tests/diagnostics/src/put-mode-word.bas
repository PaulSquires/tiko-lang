'' A PUT BLEND MODE IS A WORD, NOT A STRING. 'put (0,0), image, "xor"' is fbc's error 17,
'' "Syntax error, found 'xor'" -- the quotes are the whole mistake, and nine corpus files
'' exist to assert it.
''
'' GfxPutMode answers 0 for anything it does not recognise, and 0 reads as "no mode
'' written", so the literal was silently ignored and the PUT blended as TRANS.
dim shared as any ptr image

'' -- refused ------------------------------------------------------------------
sub refused( )
    put ( 0, 0 ), image, "xor"
    put ( 0, 0 ), image, "trans"
    put ( 0, 0 ), image, "custom"
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    put ( 0, 0 ), image, xor
    put ( 0, 0 ), image, trans
    put ( 0, 0 ), image
end sub
