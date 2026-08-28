'' A TYPE BUILT OVER SOMETHING NOT RESOLVED YET.
''
'' 'type t as u const ptr' written BEFORE 'type u as integer' resolves to a POINTER TO
'' NOTHING -- non-NONE, so 'dim as t p' looked resolved and never landed on the pending
'' list. The backpatch pass then fixed the TYPEDEF and never came back to the variable,
'' whose slot stayed void: '*p = 0' had an untyped target and declined, while the same
'' program with the two types in the other order lowered.
''
'' fbc compiles it: 'int64* P$0; P$0 = (int64*)0ull; *(int64*)P$0 = 0ll;'.
''
'' Refusing to BUILD the pointer was tried and is far too blunt -- 'any ptr' has no
'' element type either, and an unresolved 'typeof' none yet -- so it left those
'' declarations untyped instead and cost 540 corpus statements. The type is built as
'' before; the declaration is simply revisited, and the revisit now OVERRIDES what the
'' first pass left rather than being ignored as a second binding.
type t as u const ptr
type u as integer
'' 'u const ptr' is a CONST POINTER to u, so the pointer itself is assigned once, at
'' the declaration -- 'p = @target' afterwards is fbc error 119. What it POINTS AT is
'' not const, which is why the store through it is legal.
dim as integer target
dim as t p = @target
*p = 7
print *p, p <> 0
