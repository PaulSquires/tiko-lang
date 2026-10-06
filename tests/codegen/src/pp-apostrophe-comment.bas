'' A "'" in a macro's arguments is argument text, and a comment again in the statement it
'' expands to: the rest of that line goes, ':' included.
#macro t( stmt... )
stmt
#endmacro
#define S( x ) #x
dim as integer q = 5
t( print "one" '' a comment )
t( q = 7 ' : q = 9 )
print q
t( print "two" ' it's : print "never" )
#macro two( a, b )
a
b
#endmacro
two( print "first" ' gone, print "second" )
print "end"
