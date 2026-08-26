'' 'cvi<16>( s )' and 'mki<32>( n )' -- the BIT-WIDTH SPELLINGS, which had no parse.
''
'' The angle brackets parsed as RELATIONAL OPERATORS -- '(cvi < 16) > (s)' -- which is
'' a well-formed expression that means nothing, so fourteen statements in
'' string/mkcv.bas declined with no syntax error anywhere to say why.
''
'' THESE TWO ARE THE ONLY MEMBERS OF THE FAMILY THAT HAVE THE FORM. 'cvs<32>( s )' is
'' fbc's error 6, "Expected '('", so this is not a general shape to be applied by
'' analogy -- and 'cvi<8>' is its error 310, "Invalid size", so 8 is not rounded up to
'' 16 either.
''
'' The width names an entry point the compiler already reaches by another spelling --
'' measured: 'cvi<16>' is fb_CVSHORT, 'cvi<32>' is fb_CVL, 'cvi<64>' is fb_CVLONGINT --
'' so rewriting the KEYWORD in the parser is the whole implementation, exactly as
'' 'cint<16>' is already rewritten to 'cshort'.
dim as string sll = "ABCDEFGH"

print cvi<16>( sll )
print cvi<32>( sll )
print cvi<64>( sll )

print len( mki<16>( 1 ) )
print len( mki<32>( 1 ) )
print len( mki<64>( 1 ) )

'' ...and a bare 'cvi' with no width is unchanged
print cvi( sll )
