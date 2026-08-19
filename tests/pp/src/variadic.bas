'' The two rules a '#macro' header follows that a '#define' does not, both measured
'' against fbc rather than inferred.
''
''   - a space before '(' still introduces a PARAMETER list ('#define m (a)' is
''     object-like, and that C rule is '#define'-only)
''   - the trailing '...' parameter swallows the remaining arguments, COMMAS INCLUDED
''
'' fbc -pp on the same source gives 'print 1, 2, 3' and 'print 4'.

#macro spaced ( a, rest... )
print a, rest
#endmacro

spaced( 1, 2, 3 )

'' '?' after the name is the optional-parentheses marker, and the corpus writes it
'' immediately before a spaced parameter list.
#macro noparen ? ( n, stmt... )
stmt
#endmacro

noparen( 0, print 4 )
