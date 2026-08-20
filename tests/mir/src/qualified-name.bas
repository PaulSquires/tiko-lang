'' A QUALIFIED NAME -- 'ns.v', '..x' -- is bound by Resolve to the symbol itself,
'' because a namespace is not a value and has no type to wait for.
''
'' LowerAddr already had that shortcut and TypeOf_ did not, so the WRITE stored
'' correctly while the READ came back untyped and declined. One missing case produced a
'' working write and a broken read of the same name.
''
'' The second thing this pins is the truncation. 'counter' is a LONG and the literal is
'' an INTEGER, so the store needs a trunc -- and without the type it was storing 64 bits
'' into a 32-bit slot with no conversion at all. The verifier did not object.

namespace ns
	dim shared as long counter
	dim shared as integer v
end namespace

dim shared as integer g = 7

ns.counter = 2
ns.v = 3
print ns.v
print ns.counter

sub f( )
	print ..g
end sub

f( )
