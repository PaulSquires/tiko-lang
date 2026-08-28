'' A TYPE IS NOT VISIBLE IN ITS OWN 'extends' CLAUSE. 'type UDT1 extends UDT1' inside a
'' namespace names the OUTER UDT1 -- fbc compiles it and prints -1 for 'is' against the
'' inner one -- but the lookup starts in the type's own scope, found ITSELF, and the type
'' became its own base: no layout, so 'new ns1.UDT1' had nothing to size.
''
'' Stepping out ONE scope is not enough, because the NAMESPACE holds the type being
'' declared as well; and stepping out unconditionally would be wrong, because a base
'' declared BESIDE this type in the same namespace is an ordinary sibling that must
'' still be found. So the retry happens only when the answer IS this type.
type UDT1 extends Object
end type
namespace ns1
	type UDT1 extends UDT1
	end type
	type UDT2 extends UDT1
	end type
end namespace
dim pudt1 as UDT1 ptr = new ns1.UDT1
print ( *pudt1 is ns1.UDT1 ), ( *pudt1 is ns1.UDT2 )
delete pudt1
dim pudt2 as UDT1 ptr = new ns1.UDT2
print ( *pudt2 is ns1.UDT1 ), ( *pudt2 is ns1.UDT2 )
delete pudt2
