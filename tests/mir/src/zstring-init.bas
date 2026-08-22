'' A POINTER SUBSCRIPT HAS A TYPE, and a FIXED-LENGTH NARROW STRING has an initialiser.

'' 'p[i]' was never typed -- not because the case was missing but because N_INDEX was
'' missing from the LIST OF KINDS Check walks, so the type function had the answer and
'' nothing ever asked it. LowerSwap had grown a private workaround for exactly this.
sub P( )
    dim as byte ptr pa = 0
    dim as integer i = 1
    pa[i] = 5
    dim as long v = pa[0]
end sub

'' A ZSTRING * N has no descriptor: it is a char array. The LENGTH ARGUMENTS are the
'' whole story, and the destination passes its ELEMENT COUNT, never -1 -- passing -1
'' for a fixed-length operand tells the runtime to read a descriptor out of character
'' data.
''
'' Measured, including the one row that is not guessable from the others: a DESCRIPTOR
'' source goes through fb_StrInit while the other two go through fb_StrAssign.
sub Q( )
    dim t as zstring * 50 = "  ab  "     '' fb_StrAssign( T,  50, lit, 7,  0 )
    dim r2 as zstring * 50 = t           '' fb_StrAssign( R2, 50, T,   50, 0 )
    dim rt as zstring * 50 = trim( t )   '' TempDescZ, fb_TRIM, fb_StrInit( .., -1, 0 )
end sub
