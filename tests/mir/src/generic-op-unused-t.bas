'' A generic GLOBAL OPERATOR and a type argument NOTHING EVER APPLIES IT TO.
''
'' 'Box( of string )' is declared and used here; 'operator +' is used only at
'' T = integer. fbc instantiates the operator BY USE SITE, so it emits the integer
'' body and NOTHING for string. tiko instantiates by the TYPE's instantiation, so it
'' emits both -- the golden beside this file has the string '+' in it, and that is
'' the divergence, not the intent.
''
'' MEASURED 2026-09-09, fbc-modern/fbc64 -r on this exact shape:
''
''     static struct $3BoxIu7INTEGERE _ZplR3BoxIu7INTEGERES2_( ... )   <- the only one
''     static void _ZN3BoxI8FBSTRINGEC1Ev( ... )                       <- members, yes
''     static void _ZN3BoxI8FBSTRINGEaSERKS1_( ... )
''     static void _ZN3BoxI8FBSTRINGED1Ev( ... )
''
'' -- the type's MEMBERS are instantiated for string, the global operator is not.
''
'' The same probe with an ILL-TYPED body ('operator *' whose body multiplies two
'' T's) also compiles clean under fbc for exactly this reason, and is what
'' tests/vendor/fbc-tests/generics/global-operators.bas trips over: tiko
'' instantiates 'operator *' at T = string, the body is string * string, and
'' lowerassign.bas declines it. Applying that operator at T = string really is an
'' error in fbc -- "error 20 ... in instantiation of 'operator *( of string )'" --
'' so there is nothing for lowering to lower; the spurious instantiation is the bug.
''
'' Why it is not fixed here: instantiation needs the parser, which only Resolve
'' holds, and selecting an operator at a use site needs operand types, which only
'' Check computes -- and Check runs after Resolve. See the comment on
'' InstantiateGlobalOpsFor_ in src/symbols/generic.bas.
''
'' This test pins the current output so a lazy-instantiation fix shows up as a
'' golden diff rather than silently.

type Box( of T )
	as T v
end type

operator + ( of T )( byref x as Box( of T ), byref y as Box( of T ) ) as Box( of T )
	dim as Box( of T ) r
	r.v = x.v + y.v
	return r
end operator

dim as Box( of string ) s1
s1.v = "ab"

dim as Box( of integer ) i1, i2
i1.v = 3 : i2.v = 4

dim as Box( of integer ) m = i1 + i2
print m.v, s1.v
