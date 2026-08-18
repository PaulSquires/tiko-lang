'' The tuple type's own diagnostics.
''
'' Tuple syntax is brand new, so every case here is something that was already
'' an error before the feature existed. What is pinned is the WORDING and the
'' choice of message, not the fact that it fails.

#print === a tuple needs at least two elements ===
'' '(x)' has to keep meaning a parenthesised expression everywhere else in the
'' language, so there is no 1-tuple and no 0-tuple.
type OneElem as (long)

#print === duplicated element name ===
'' Names are discarded, but a duplicate is still a mistake worth naming.
type DupName as (x as long, x as long)

#print === ANY is not a storable element ===
type AnyElem as (any, long)

#print === a fixed-length string is not a storable element ===
type FixStrElem as (string * 4, long)

#print === only the FIRST bad element is reported ===
'' Two bad elements, one diagnostic: fbc's one-error-per-statement filter
'' suppresses the rest. Pinned so the behaviour is a decision rather than a
'' surprise -- parsing continues past a bad element precisely so the list is
'' consumed, not so that every element gets its own message.
type TwoBad as (any, string * 8, long)

#print === a tuple is not a base class ===
'' No vtable, no RTTI, and no identity to inherit, so EXTENDS does not opt in.
type Derived extends (long, long)
	as long f
end type

#print === unterminated element list ===
sub unterminated( )
	dim p as (long, long
end sub

#print === SIZEOF cannot take a tuple type ===
'' A DOCUMENTED limitation, pinned here on purpose so it cannot change by
'' accident. cTypeOrExpression() commits to "this is a type" before parsing and
'' relies on cSymbolType() failing without consuming anything, which the tuple
'' arm cannot promise; three tokens of look-ahead cannot tell '( a )' from
'' '( T ptr, U )'. The workaround is a typedef:
''     type P as (long, string) : print sizeof( P )
'' See docs/tuples/RFC-0001-tuple-type.md section 10.
sub sizeofTuple( )
	print sizeof( (long, string) )
end sub

#print === TYPEOF cannot take a tuple type ===
sub typeofTuple( )
	dim x as typeof( (long, string) )
end sub

#print === a tuple constant is not accepted ===
const c as (long, long) = 0

#print === a nested tuple literal is not context-typed ===
'' A DOCUMENTED limitation. The outer literal's elements are parsed before the
'' outer target type has been applied, so an inner literal only gets whatever
'' context is already open. Inner elements whose natural type already matches
'' are fine -- '((1,2), 3)' into '((double,double), long)' works, because an
'' integer literal converts to double at the field. A string LITERAL is not a
'' STRING, so this one does not.
''
'' The workaround is to build the inner tuple first:
''     dim inner as (long, string) = (1, "x")
''     dim n as ((long, string), long) = (inner, 3)
sub nestedLiteral( )
	dim n as ((long, string), long) = ((1, "x"), 3)
end sub

#print === destructuring: too FEW targets ===
'' Both directions are checked now. Before tuples existed only 'too many' was,
'' so 'LET(i, j) = <a three-field UDT>' silently dropped the third.
sub tooFew( )
	dim f1 as long, f2 as long
	dim ft as (long, long, long)
	(f1, f2) = ft
end sub

#print === destructuring: too MANY targets ===
sub tooMany( )
	dim m1 as long, m2 as long, m3 as long
	dim mt as (long, long)
	(m1, m2, m3) = mt
end sub

#print === destructuring a non-tuple with the tuple form ===
'' Positional unpacking of a NAMED type stays LET-only: reordering that type's
'' fields would silently change every unpack site.
type NotATuple
	as long a
	as long b
end type
sub notATuple( )
	dim nn as NotATuple
	dim n1 as long, n2 as long
	(n1, n2) = nn
end sub

#print === destructuring a scalar ===
sub notEvenAggregate( )
	dim s1 as long, s2 as long
	(s1, s2) = 42
end sub

#print === var (a, b) needs at least two names ===
sub varOne( )
	var (a) = 1
end sub

#print === var (a, b) takes identifiers, not lvalues ===
sub varNotIdent( )
	dim arr(1 to 3) as long
	var (arr(1), b) = (1, 2)
end sub

#print === var (a, b) arity must match ===
sub varArity( )
	var (a, b, c) = (1, 2)
end sub

#print === ordering operators are not defined on tuples ===
'' Lexicographic order is only sometimes what the writer meant, and when it is
'' not the code still compiles and sorts wrong. Equality has no such ambiguity.
'' A pure addition if it is ever wanted -- RFC-0004 section 2.
sub ordering( )
	dim o1 as (long, long)
	dim o2 as (long, long)
	print (o1 < o2)
end sub

#print === two DIFFERENT tuple types do not compare ===
sub crossType( )
	dim x1 as (long, long)
	dim x2 as (double, double)
	print (x1 = x2)
end sub
