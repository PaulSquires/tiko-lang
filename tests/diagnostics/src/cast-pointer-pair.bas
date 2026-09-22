'' TKO0804 and TKO0805: a cast between a POINTER and something that is not one -- fbc's
'' error 28, for 'cast' and 'cptr' alike. The controls at the bottom are accepted by fbc.
type UD
    v as long
end type
dim as any ptr pa
dim as long ptr pl
dim as long i
dim as integer ii
dim as longint li
dim as double d
dim as string s
dim as ustring u
dim as UD ud

'' A pointer target, and an operand that is not a pointer or a pointer-sized integer.
print cptr( any ptr, i )
print cptr( any ptr, d )
print cast( any ptr, s )
print cptr( long ptr, ud )
print cptr( any ptr, true )

'' A pointer operand, and a target that is neither.
print cptr( long, pa )
print cast( double, pa )
print cptr( boolean, pa )
print cptr( UD, pa )
print cptr( zstring * 4, pa )

'' Accepted by fbc: a pointer both sides, a pointer-sized integer either side, and an
'' ordinary conversion with no pointer in it. A ustring cast over a ustring is one too.
print cptr( any ptr, pl )
print cptr( any ptr, ii )
print cptr( any ptr, li )
print cptr( any ptr, 0 )
print cptr( any ptr, @i )
print cptr( integer, pa )
print cast( integer, pa )
print cptr( long, i )
print cptr( double, d )
print cast( ustring, u )
print cptr( ustring, u )
print cptr( string, s )
