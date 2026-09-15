'' AN INTEGER CAST OVER A POINTER OF ITS SIZE, AS A TARGET. AfxNova's child-enumeration callbacks
'' write 'CAST( LPARAM, pItem ) = lPrm', and the statement was dropped: an integer and a pointer
'' were different "families" to the conversion-free-cast rule, although fbc stores straight into the
'' operand. Measured, fbc-modern:
''
''     cast( integer, bp ) = 16        BP = (int8*)16ll
''     cast( integer, bp ) += 8        BP = (int8*)((int64)BP + 8ll)
''     @cast( integer, bp )            (int64*)&BP
''
'' and prints 16, 24, 40, -1 and 77. So does tiko. 'cptr( any ptr, bp ) = @ln' already lowered.
dim as byte ptr bp
dim as long ln = 77
cast( integer, bp ) = 16
print cast( integer, bp )
cast( integer, bp ) += 8
print cast( integer, bp )
cast( uinteger, bp ) = 40
print cast( integer, bp )
dim as integer ptr pi = @cast( integer, bp )
print ( pi = cptr( integer ptr, @bp ) )
cptr( any ptr, bp ) = @ln
print *cptr( long ptr, bp )
