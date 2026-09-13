'' 'procptr( T.m )' OVER AN ABSTRACT MEMBER IS NULL. Measured, fbc prints -1 for both
'' tests below. tiko took the address of a declaration nothing defines: at -O0 the link
'' failed, and at -O2 LLVM assumed the address non-null and folded the test to 0
'' (pointers/procptr-virtual.bas, 'abstracts').
type B extends object
	declare abstract sub proc1()
	declare virtual sub proc2()
end type
sub B.proc2()
end sub
type D extends B
	declare sub proc1()
end type
sub D.proc1()
end sub
var fp = procptr( B.proc1 )
print cint(fp) = 0
var fq = procptr( B.proc2 )
print cint(fq) <> 0
