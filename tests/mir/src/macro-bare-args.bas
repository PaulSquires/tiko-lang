'' '#macro NAME ? ( a, b )' MAY BE INVOKED WITHOUT PARENTHESES. fbc accepts all six
'' spellings below and every one of them prints '$"1 2 3" $"4 5 6"' -- measured by
'' running it -- so the six are one answer written six ways. Four separate defects stood
'' between tiko-lang and that answer, and each one alone produced a WRONG STRING rather
'' than a decline.
''
'' A NESTED BARE MACRO CLAIMS ITS OWN COMMAS. 'foo( bar 1, 2, 3, baz( 4, 5, 6 ) )' is
'' TWO arguments to foo, because bar takes three. Splitting on every comma at the
'' separator depth reported "macro 'foo' takes 2 argument(s)".
''
'' THE BARE FORM DOES NOT END AT A ')'. It starts at depth zero, so the ')' closing a
'' parenthesised argument brought the depth back to zero and ended the invocation one
'' argument in.
''
'' A BARE ARGUMENT IS EXPANDED BEFORE IT IS SUBSTITUTED. Substitution pushes raw tokens
'' and lets the rescan expand them; here that put 'bar 1, 2, 3' next to 'baz( 4, 5, 6 )'
'' in one buffer, and 'bar' read bare runs to end of line, so its third argument
'' swallowed the lot: '$"1 2 3 $""4 5 6""' against fbc's '$"1 2 3" $"4 5 6"'.
''
'' AND THE ARGUMENT'S LEADING SPACE SURVIVES THAT. Relexed tokens carry the spacing of
'' the synthesised text, so two bare arguments in a row came out with no space between
'' them.
#macro foo ? ( a, b )
	__fb_quote__( a b )
#endmacro

#macro bar ? ( a, b, c )
	__fb_quote__( a b c )
#endmacro

#macro baz ? ( a, b, c )
	__fb_quote__( a b c )
#endmacro

dim s as string

s = foo( bar( 1, 2, 3 ), baz( 4, 5, 6 ) )
print s

s = foo( bar 1, 2, 3, baz( 4, 5, 6 ) )
print s

s = foo( bar( 1, 2, 3 ), baz 4, 5, 6 )
print s

s = foo( bar 1, 2, 3, baz 4, 5, 6 )
print s

s = foo bar( 1, 2, 3 ), baz( 4, 5, 6 )
print s

s = foo bar 1, 2, 3, baz 4, 5, 6
print s
