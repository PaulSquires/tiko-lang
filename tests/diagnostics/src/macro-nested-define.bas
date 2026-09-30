'' A #macro inside a #macro body nests; its #endmacro does not end the outer one.
#macro create_macro( name_, params_, body_ )
	#undef name_
	#macro name_ params_
		body_
	#endmacro
#endmacro
create_macro( twice, (x), (x) * 2 )
dim as integer ok = twice( 21 )
nosuch = 1                                      '' refused: proves the outer macro ended
