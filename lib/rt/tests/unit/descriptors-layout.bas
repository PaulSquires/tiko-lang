'' descriptors-layout.bas -- S1's acceptance test.
''
'' The #assert blocks inside config.ti and descriptors.ti do the real work; this
'' module exists so that build/test.sh compiles them for every target and every
'' threading mode. A layout invariant that is only checked on win64 is checked on
'' the one target where every platform distinction collapses.

#include once "inc/descriptors.ti"

extern "rtlib"
	'' Referenced so nothing is dead-stripped before the asserts are evaluated.
	function tkort_LayoutProbe( ) as integer
		return sizeof( FBSTRING ) + sizeof( FBUSTRING ) + sizeof( FBARRAYDIM ) _
		     + sizeof( FB_LIST ) + sizeof( FB_ERRORCTX ) + sizeof( FB_STR_TMPDESC )
	end function
end extern
