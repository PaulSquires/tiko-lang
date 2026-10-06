type SomeUDT
	dummy as integer
	static i as integer
	static byref ri as integer
end type
dim shared SomeUDT.i as integer = &h445566
dim shared byref SomeUDT.ri as integer = SomeUDT.i
print SomeUDT.ri = &h445566, SomeUDT.ri + 1
dim as integer k = SomeUDT.ri
print k
SomeUDT.ri = 7
print SomeUDT.i
namespace ns
	dim shared j as integer = 40
	dim shared byref rj as integer = j
end namespace
print ns.rj + 2, ns.rj = 40
ns.rj += 1
print ns.j
