'' A '#macro' EXPANSION HAS NO TRAILING END-OF-LINE. The capture pushes every token
'' between the header line and '#endmacro', so the run ends with the last body line's
'' EOL -- a token fbc's model does not have. In expression position that split the
'' statement: 's = h( ) + h( )' is one statement to fbc and was 'expected a statement'
'' at the '+' here, which is what pp/macro_trim.bas is six of.
''
'' Trimming it AT DEFINITION was tried three times and reverted three times, because
'' __FB_ARG_LISTEXPAND__ synthesises 'M( 1 ) : M( 2 ) : M( 3 )' as TEXT and relies on
'' each repetition ending where it does. Two call-site tests were tried as well; the
'' note after the third attempt says why they could not work -- the dependency is INSIDE
'' an expansion, not at its call site.
''
'' TF_SYNTHESISED is the distinction, and TF_FROM_MACRO is not: 'h( )' written inside
'' another macro's argument list is carried into that macro's body and takes
'' TF_FROM_MACRO on the way, while still being a name the program wrote. Only RelexInto
'' sets TF_SYNTHESISED.
''
'' Every value here was measured by running fbc.
#macro h( )
	"hello"
#endmacro

# macro padded( )
	 	

	"world!"
	 
# endmacro

#define chk( a, b ) if (a) <> (b) then print "MISMATCH"

dim s as string

'' Two expansions in one expression: the trailing EOL used to end the statement after
'' the first.
s = h( ) + h( )
print s

'' The same, one level down -- the invocation is read out of chk's body buffer, so the
'' name carries TF_FROM_MACRO and must still be trimmed.
chk( h( ) + h( ), "hellohello" )

'' Blank and whitespace-only lines at either end of the body are not part of it.
s = h( ) + padded( )
print s
print len( s )
