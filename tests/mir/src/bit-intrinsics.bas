'' BIT / BITSET / BITRESET, none of which existed: every one of them declined, and
'' pp/bit___.bas is fourteen statements of nothing else.
''
'' Measured -- over a LONGINT, a LONG and a UBYTE alike, fbc widens the operand to
'' LONGINT and keeps it there, and masks the index with 63 whatever the operand's
'' width:
''
''   bit( c, j )        (int64)-((C$0 & (1ll << (J$0 & 63ll))) != 0ll)
''   bitset( c, j )     C$0 | (1ll << (J$0 & 63ll))
''   bitreset( c, j )   C$0 & ~(1ll << (J$0 & 63ll))
''   bitset( l, j )     (int32)((int64)L$0 | (1ll << (J$0 & 63ll)))
''
'' -- so the narrowing back to LONG in 'l = bitset( l, j )' comes from the ASSIGNMENT
'' and not from the intrinsic, whose own type is LONGINT.
''
'' BIT's result is 0 or -1, not 0 or 1: it is the NEGATED comparison, which is what
'' makes 'bit( 224, 5 ) = -1' true. Read as a plain mask it would have been 32.
dim as longint c = 0
dim as long l = 0
dim as ubyte b = 224
dim as integer j = 3

c = bitset( c, j )
print bit( c, j ), bit( c, 2 )
c = bitreset( c, j )
print bit( c, j )

l = bitset( l, 5 )
print l, bit( l, 5 )

print bit( b, 5 ), bit( b, 4 )
print bit( 224, 5 ), bit( 224, 4 )
