'' A NAMED CONSTANT IN A STATIC OR SHARED AGGREGATE INITIALISER. The image fold called
'' ConstOf without the symbol table -- 'if syms = 0 then return CVNone_( )' for every
'' identifier -- so a const name did not fold and the whole image declined, while the
'' same literal in the same slot did. fbc writes 'static int64 ARR$[2] = { 42ll, 2ll };'
'' and prints ' 42  2'.
''
'' Lowering has no scope of its own, so the fold takes the node's own recorded scope,
'' then the PROCEDURE's -- a 'static' local's initialiser is folded while lowering the
'' procedure, and the constant it names may be in the namespace that procedure lives in
'' rather than at file level, which is what pointers/casting1.bas writes.
const TEST_VAL = 42

dim shared as integer arr(0 to 1) = { TEST_VAL, 2 }
print arr(0), arr(1)

namespace ns
	const INNER = 7

	type udt
		as integer abc
	end type

	function f( ) as integer
		static as udt t = ( INNER )
		return t.abc
	end function
end namespace

print ns.f( )

'' 'open ... len = <expression>' IN EXPRESSION POSITION. The record length lives in the
'' intrinsic payload's third slot, which the resolve walk did not visit, so 'n' was
'' unresolved and the whole expression declined -- while a foldable 'len = 8 + 8'
'' worked, and so did the same OPEN written as a STATEMENT.
dim as integer n = 16
dim as string fn = "const-in-static-init.tmp"
if open( fn for binary as #1 len = n ) = 0 then
	print "opened"
	close #1
	kill fn
end if
