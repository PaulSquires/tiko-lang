'' A UDT LOOP COUNTER IS THE OPERATOR PROTOCOL, NOT ARITHMETIC. 'for i as T = T(1) to
'' T(3)' over a type declaring 'operator for/step/next' was lowered as though T were a
'' number:
''
''     %12 = load @i              an AGGREGATE loaded as a value
''     %14 = icmp.sle %12, %13    two aggregates compared with an integer compare
''     %18 = const agg 1          a constant aggregate of value 1
''     %19 = add %17, %18         two aggregates ADDED
''
'' It reported "0 statements not lowered", it PASSED THE VERIFIER, and then the LLVM
'' emitter met an aggregate with no storage and died with 'ICE: an aggregate value with
'' no size'. mirsweep never saw any of it -- '--dump-ir' stops before codegen -- and
'' tests/diagnostics/operator-visibility's golden had FROZEN the meaningless IR.
'' build/icescan.sh is the instrument that found it.
''
'' This DECLINES now, which is honest rather than right. fbc's protocol is measured and
'' in HANDOFF: construct the counter and the limit, call 'operator for' on the counter,
'' TEST FIRST through 'operator next( counter, limit )', body, 'operator step', test
'' again. Building it needs a member call that yields a RESULT -- EmitStructorCall is a
'' sub and 'next' returns an integer.
''
'' fbc compiles and runs this file, printing 1 2 3.
type T
	as integer x
	declare constructor( )
	declare constructor( byval x as integer )
	declare operator for( )
	declare operator step( )
	declare operator next( byref end_cond as T ) as integer
end type

constructor T( )
end constructor

constructor T( byval x as integer )
	this.x = x
end constructor

operator T.for( )
end operator

operator T.step( )
	this.x += 1
end operator

operator T.next( byref end_cond as T ) as integer
	return this.x <= end_cond.x
end operator

for i as T = T(1) to T(3)
	print i.x
next
