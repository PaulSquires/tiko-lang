'' a qualified dim -- relative inside the namespace, or full outside it -- defines its extern
namespace varA
	namespace varB
		extern i2 as integer
		extern i3 as integer
	end namespace
	extern i5 as integer
	dim varB.i2 as integer
end namespace
dim varA.varB.i3 as integer
dim varA.i5 as integer
varA.varB.i2 = 2 : varA.varB.i3 = 3 : varA.i5 = 5
print varA.varB.i2, varA.varB.i3, varA.i5
