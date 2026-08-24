'' 'procptr( T.m, VIRTUAL )' IS NOT A POINTER AT ALL.
''
'' Measured against fbc: it folds to the member's VTABLE SLOT INDEX as an int64 --
''
''     var fp = procptr( B.proc2, virtual )    FP$0 = 1ll;
''     var fq = procptr( B.proc1, virtual )    FQ$0 = 0ll;
''
'' -- which is exactly what pointers/procptr-virtual.bas asserts, against its own INDEX
'' constants. tiko-lang read the second argument as an OVERRIDE SELECTOR that "does not
'' change the result type", so the expression was typed as a procedure pointer, 'var fp'
'' got a VOID slot and every one of them declined.
''
'' An ABSTRACT member has a slot too, and it is the one its overrides fill.
type B extends object
	declare abstract sub proc1( )
	declare virtual sub proc2( )
	declare virtual sub proc3( )
end type

sub B.proc2( )
end sub

sub B.proc3( )
end sub

var fq = procptr( B.proc1, virtual )
var fp = procptr( B.proc2, virtual )
var fr = procptr( B.proc3, virtual )
print cint( fq ), cint( fp ), cint( fr )

'' A DERIVED TYPE'S OVERRIDE ANSWERS -1, not the slot it occupies. Written as a plain
'' 'declare sub proc1( )' it fills the base's slot and is dispatched through it -- and
'' fbc still answers -1 here, because the DECLARATION ITSELF says neither VIRTUAL nor
'' ABSTRACT. Measured, and the answer is a CONSTANT either way rather than a decline.
type D extends B
	declare sub proc1( )
	declare sub proc2( )
end type

sub D.proc1( )
end sub

sub D.proc2( )
end sub

print cint( procptr( D.proc1, virtual ) ), cint( procptr( D.proc2, virtual ) )
