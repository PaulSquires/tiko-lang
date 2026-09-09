'' ANY USE OF A RESERVED NAME is fbc 325, "Illegal use of reserved symbol" -- not just
'' the 'sizeof( symbol )' the survey recorded. Measured, all four are 325:
''
''     print foo        foo = 1        sizeof( foo )        dim as integer x = foo
''
'' DECLARING one is a different error, fbc 4, and has its own test: a declaration
'' carries the name on an N_VAR_ITEM payload and creates no identifier node, so the two
'' rules cannot report on the same thing.
''
'' THIS IS SAFE WHERE THE GENERAL RULE IS NOT. fbc answers 42 for an UNDECLARED name and
'' that rule was withdrawn here -- a type name reaches the checker as a plain N_IDENT
'' too, so "unbound" is not "undeclared", and the scan refused eight COM files fbc
'' accepts. A RESERVED name carries no such doubt: the source itself put it on the list.
#pragma reserve foo

print foo
