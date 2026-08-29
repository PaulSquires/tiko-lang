'' '#assert defined( X )' -- THE OPERAND OF 'defined' MUST NOT EXPAND, which is the rule
'' '#if' applies and '#assert' had no share of: over a '#macro M2', this substituted M2's
'' BODY between DEFINED and ')' and the line became TKO0401. fbc compiles it clean.
#macro M2
	#define ABC
#endmacro
M2
#assert defined( M2 )
#assert defined( ABC )

'' AN EMPTY ASM BLOCK EMITS NOTHING, and that is not something to refuse. Inline assembly
'' is declined by design, with a diagnostic -- but pp/pragma-reserve-7.bas writes a block
'' whose whole body is a '#if' that yields no tokens, and its subject is the '#pragma
'' reserve' above it. There is no assembly there to refuse.
#pragma reserve (asm) symbol

asm
	#if defined( symbol )
		#error
	#endif
end asm

print "ok"
