' TEST_MODE : COMPILE_ONLY_FAIL

'' A type that EXTENDS ComPtr does not inherit its arrow.
''
'' operator -> is a global generic declared over ComPtr( of T ), and T is
'' inferred by matching the operand against that pattern; MyPtr( of IFoo ) does
'' not match it, because the name differs.  This is the defect that made
'' ComQIPtr declare its own pair (RFC-0003 section 2), and it is pinned here so
'' that anyone extending ComPtr meets it as a documented rule rather than as a
'' surprise.
''
'' NOTE: the arrow appears to work if some EARLIER line in the same module used
'' it on a ComPtr( of IFoo ), because that instantiates a concrete operator over
'' the base which a derived operand then binds to.  This file deliberately does
'' not do that -- which is the whole point.
''
'' The fix is to declare operator * and operator -> over the derived type too.

#include once "fb/comptr.bi"
using FB

type IThing extends ComUnknown
	declare abstract function Poke( ) as long
end type

type MyPtr( of T ) extends ComPtr( of T )
	as long extra
end type

dim as MyPtr( of IThing ) p
print p->Poke( )
