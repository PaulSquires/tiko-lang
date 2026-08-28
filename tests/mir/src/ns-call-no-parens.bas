'' A NAMESPACE-QUALIFIED PROCEDURE NAMED WITHOUT PARENTHESES IS A CALL, and its type is
'' its RESULT -- which is what a SYM_PROC's own type holds and what the BARE form already
'' used. 'CpuClock.IsSupported' is how fb/chrono.bi's test asks, and fbc emits
'' 'boolean vr$0 = _ZN2NS11ISSUPPORTEDEv( )' for it: the same call the parenthesised
'' spelling makes. Left untyped, the member was a value of no type and the statement
'' declined while 'NS.IsSupported( )' beside it lowered.
namespace NS
	private function IsSupported( ) as boolean
		return true
	end function
end namespace
print NS.IsSupported
print NS.IsSupported( )
