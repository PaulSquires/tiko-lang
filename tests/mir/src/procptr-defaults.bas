'' A CALL THROUGH A PROCEDURE POINTER PASSES THE POINTER DECLARATION'S DEFAULTS. Every
'' shape below printed, run under fbc, exactly what tiko's build of it prints:
''
''    1001 2002 3003 2005
''    3002 2003
''    107 109 207 307 407 507 1004 3004 6123 102
''
'' -- the default is the POINTER's, not the procedure's: 'swap' moves the addresses and
'' leaves each variable's default, and 'fq' over g3 passes FP2's 7 though g3 has none.
function f1( byval arg as long ) as long : return 1000+arg : end function
function f2( byval arg as long = 2 ) as long : return 2000+arg : end function
function f3( byval arg as long = 3 ) as long : return 3000+arg : end function
function g3( byval i as integer, byval j as integer ) as integer : return i*100 + j : end function
type FP2 as function( byval as integer, byval as integer = 7 ) as integer
function h( ) as FP2 : return @g3 : end function
function f4( byval f as function( byval arg as long = 4 ) as long ) as long : return f() : end function
type T
    s1 as function( byval c as long, byval v as long = 123 ) as long
end type
function chk( byval c as long, byval v as long ) as long : return c*1000 + v : end function
var pf1 = procptr( f1 )
var pf2 = procptr( f2 )
var pf3 = procptr( f3 )
print pf1(1); pf2(); pf3(); pf2(5)
swap pf2, pf3
print pf2(); pf3()
dim fq as FP2 = @g3
dim fr as function( byval as integer, byval as integer = 9 ) as integer = @g3
dim pfq as FP2 ptr = @fq
dim fa(1) as FP2
fa(0) = @g3
dim x as T
x.s1 = @chk
print fq(1); fr(1); (*pfq)(2); pfq[0](3); fa(0)(4); h()(5); f4(pf1); f4(pf2); x.s1(6); fq(1, 2)
