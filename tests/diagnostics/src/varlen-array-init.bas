'' A VAR-LEN ARRAY CANNOT BE INITIALIZED -- fbc error 75, measured over four spellings
'' and identical in every one. tiko-lang accepted all four and wrote the initialiser into
'' a descriptor that had not been allocated.
''
'' A FIXED array initialises fine, and so does 'dim a(0 to 1) as integer = any': the rule
'' is about having no storage yet, not about the initialiser's shape.
redim a( 0 to 1 ) as integer => { 1, 2 }
redim b( 0 to 1 ) as integer = 5
dim c( ) as integer => { 1, 2 }
dim d( any ) as integer => { 1, 2 }

'' Accepted, both of them.
dim e( 0 to 1 ) as integer => { 1, 2 }
dim f( 0 to 1 ) as integer = any
