'' '#pragma reserve [ ( asm [, extern] ) ] name' -- the option list and the collision rule,
'' both measured against fbc.
''
'' PLAIN, ASM and EXTERN are three INDEPENDENT modes, which is not obvious: '(asm)' then
'' '(extern)' on one name is accepted, either one twice is fbc's error 4, and a BARE
'' reserve is its own mode rather than shorthand for both -- 'reserve x' then
'' 'reserve (asm) x' is accepted while 'reserve x' twice is not. A collision is a non-empty
'' intersection of the two mode sets.
''
'' NOT MODELLED HERE: what the reservation then FORBIDS. fbc refuses a later declaration of
'' a reserved name (error 4) and a use of one (error 325), and refuses the directive itself
'' inside a scope or a procedure (96 and 61). Those need the reserved names to reach the
'' symbol phase and the directive to know its block nesting; the preprocessor has neither.
'' Accepted: different names, disjoint modes, and the tolerated spellings.
#pragma reserve (asm) alpha
#pragma reserve (extern) alpha
#pragma reserve (asm) beta
#pragma reserve gamma
#pragma reserve (asm) gamma
#pragma reserve (asm extern) delta
#pragma reserve ( ) epsilon
#pragma reserve (asm,extern) zeta
'' Refused: an option that is neither 'asm' nor 'extern'.
#pragma reserve (shared) eta
'' Refused: the modes intersect.
#pragma reserve (asm) beta
#pragma reserve theta
#pragma reserve theta
#pragma reserve (asm,extern) zeta
