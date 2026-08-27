'' A '_' CONTINUES THE LOGICAL LINE, AND THE REST OF THAT PHYSICAL LINE IS DISCARDED.
'' Measured, and it is not the narrow rule this used to apply -- fbc throws away
'' everything after the '_', not just a trailing comment:
''
''     y = 1 + _ junk ) here      y = 1 + 2
''         2
''
'' Requiring the line to END after the '_' meant a continuation inside a MACRO ARGUMENT
'' LIST was lexed as an identifier and the logical line stopped there, so 'chk( x, _ )'
'' with the rest on the next line came out as the wrong argument count.
''
'' WHAT FOLLOWS THE '_' IMMEDIATELY decides, and only that: an identifier character
'' makes it a NAME -- '_x' and '_ab' are identifiers -- and anything else, INCLUDING A
'' SPACE, makes it a continuation.
#macro chk( a, b, c )
    print a, b, c
#endmacro

dim as long _x = 5
dim as long _ab = 7
print _x, _ab

dim as long y
y = 1 + _ junk ) here
    2
print y

chk( 1, _ )
     2, 3 )

chk( 10, _
     20, 30 )
