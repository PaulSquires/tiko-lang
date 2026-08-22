'' __FB_ARG_LISTEXPAND__ and __FB_ARG_EXTRACT__.
''
'' Every number below was MEASURED against fbc's own C output. None of the chunking is
'' guessable, and the negative form is not the positive one reversed:
''
''   step = 0    one call with the whole list.
''   step = n    successive CHUNKS of n, front to back; the last one is short.
''   step = -n   successive TAILS, dropping n from the front each time and passing
''               everything that remains -- so the first call gets the whole list.
sub f( byval n as long, byval a as long, byval b as long )
end sub

#macro M( args... )
    f( __FB_ARG_COUNT__( args ), __FB_ARG_EXTRACT__( 0, args ), _
       __FB_ARG_EXTRACT__( __FB_ARG_COUNT__( args ) - 1, args ) )
#endmacro

'' fbc: F(2,1,2) F(2,3,4) F(1,5,5)
__FB_ARG_LISTEXPAND__( M, 2, 1, 2, 3, 4, 5 )
'' fbc: F(5,1,5) F(3,3,5) F(1,5,5)
__FB_ARG_LISTEXPAND__( M, -2, 1, 2, 3, 4, 5 )
'' fbc: F(5,1,5)
__FB_ARG_LISTEXPAND__( M, 0, 1, 2, 3, 4, 5 )
'' fbc: F(3,1,3) F(2,2,3) F(1,3,3)
__FB_ARG_LISTEXPAND__( M, -1, 1, 2, 3 )
'' A step wider than the list is one call with all of it, either sign.
__FB_ARG_LISTEXPAND__( M, 9, 1, 2 )
__FB_ARG_LISTEXPAND__( M, -9, 1, 2 )
'' The step may be a macro, not just a literal.
#define S 2
__FB_ARG_LISTEXPAND__( M, S, 1, 2, 3 )
'' The index of an extract is an EXPRESSION, which is how the corpus writes it.
f( 0, __FB_ARG_EXTRACT__( 1, 11, 22, 33 ), __FB_ARG_EXTRACT__( 3 - 1, 11, 22, 33 ) )
