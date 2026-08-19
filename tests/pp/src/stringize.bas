'' The stringise operator, spelled as fbc spells it. MEASURED:
''
''     #define S(a) #a
''     S( x = "5" )      ->   $"x = ""5"""      and len( ... ) is 7
''
'' A quote inside the argument is DOUBLED, or it closes the literal early: 'x = "5"'
'' used to re-lex as THREE tokens -- "x = " then 5 then "" -- which is why 113 corpus
'' files reported 'expected )' at an fbcunit assert.
''
'' The literal is '$'-prefixed, i.e. NON-escaped, so a backslash in the argument stays
'' a backslash rather than becoming an escape.
''
'' And '""' inside any literal is ONE quote on the way out: len( $"q""q" ) is 3.

#define S( a ) #a

print S( x = "5" )
print S( plain )
print S( "q" )
print $"q""q"
print "q""q"
