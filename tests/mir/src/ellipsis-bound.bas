'' '...' as an array bound: the size comes from the initializer. Measured against fbc:
''
''   dim a(0 to ...) as integer = { 1, 2, 3 }     lbound 0, ubound 2
''   dim a(...)      as integer = { 1, 2, 3 }     same -- the lower bound defaults to 0
''   dim a(0 to 1, 0 to ...)                      any dimension, and several at once
''   redim a(0 to ...)                            fbc error 76
''   a TYPE FIELD with one                        fbc error 77
''   no initializer at all                        fbc error 281
''
'' The sizes below are the point. Parsing '...' without inferring the bound leaves the
'' array typed as its ELEMENT -- eight bytes where twenty-four were needed, with nothing
'' to say so.

dim a(0 to ...) as integer = { 1, 2, 3 }
dim b(...) as integer = { 1, 2, 3 }
dim c(0 to 1, 0 to ...) as integer = { {1,2,3}, {4,5,6} }
dim d(0 to ..., 0 to 2) as integer = { {1,2,3}, {4,5,6} }
dim e(...) as string = { "x", "y" }
dim f(0 to 2) as integer = { 1, 2, 3 }

print 1
