'' AN ARRAY IS INDEXED WITH AS MANY SUBSCRIPTS AS IT HAS DIMENSIONS -- fbc error 36,
'' "Wrong number of dimensions". Measured: 'a( 0 )' over 'a( 0 to 1, 0 to 1 )' is refused,
'' and so is a 'redim' that changes the count.
''
'' NONE AT ALL IS THE WHOLE-ARRAY SPELLING and is left alone; a DYNAMIC array records -1
'' for its rank and is not asked, because its shape is whatever the last redim made it.
''
'' A FIXED-LENGTH STRING is an array of a character builtin, so it is not asked either --
'' the fourth time this run that representation has had to be told apart from a real array.
declare sub takesArray( a( ) as integer )

dim shared as integer one( 0 to 1 )
dim shared as integer two( 0 to 1, 0 to 1 )
dim shared as zstring * 8 z

'' -- refused ------------------------------------------------------------------
sub refused( )
    print two( 0 )
    print one( 0, 0 )
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    print one( 0 )
    print two( 0, 0 )
    takesArray( one( ) )
    print z
end sub
