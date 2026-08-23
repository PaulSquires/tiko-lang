'' A MACRO PARAMETER MAY BE NAMED AFTER A KEYWORD. fb/mathint.bi writes
'' '#macro __FB_MI_BITS( T, WIDTH, MASKALL )', and WIDTH is the WIDTH statement.
'' Measured against fbc: it accepts the declaration and substitutes the parameter
'' like any other.
''
'' Only the DECLARATION rejected it, so the macro was recorded as taking TWO
'' parameters and every use reported 'takes 2 argument(s)' -- the whole header
'' failed to parse, and with it every test written against the module.
#macro BITS( T, WIDTH, MASKALL )
	dim as T v_##WIDTH = WIDTH
	print v_##WIDTH, MASKALL, #WIDTH
#endmacro

BITS( ubyte, 8, &hFF )
BITS( ushort, 16, &hFFFF )
