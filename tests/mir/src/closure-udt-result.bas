'' A CLOSURE CALL'S UDT RESULT IS BUILT WHERE IT IS WANTED, not copied bitwise. fbc's C for
'' 'dim outcome as Res = work( )' is '__FBINVOKE( &OUTCOME, WORK )': the object is built in
'' place once. tiko default-constructed the variable, called into a temporary, stored the
'' temporary's bytes over it and then destroyed the temporary -- two owners of one ustring
'' buffer, a use-after-free on the next read and a double free (0xC0000374) on the way out.
'' fbsqlite's WithTransaction, whose failing body returns a Result carrying a DbError, died
'' exactly there. A call to a NAMED function beside it was already right.
''
'' fbc prints, with the counted type below: the Res ctor/copy/dtor lines of each call, then
'' each 'msg=' line reading 'no such column: insert x', and never a garbled message.
type Res
	as long code
	as ustring msg
	declare constructor( )
	declare constructor( byref o as Res )
	declare destructor( )
end type
constructor Res( )
	print "Res ctor"
end constructor
constructor Res( byref o as Res )
	code = o.code : msg = o.msg
	print "Res copy "; msg
end constructor
destructor Res( )
	print "Res dtor "; msg
end destructor
type Plain
	as long code
	as ustring msg
end type
function Fail( byref sql as ustring ) as Res
	dim r as Res
	r.code = 1 : r.msg = "no such column: " & sql
	return r
end function
function FailPlain( byref sql as ustring ) as Plain
	dim r as Plain
	r.code = 1 : r.msg = "no such column: " & sql
	return r
end function
function WithWork( of Body )( byref work as Body ) as Plain
	dim outcome as Plain = work( )
	if outcome.code <> 0 then return outcome
	return outcome
end function
dim as ustring q = "insert x"
var f = function[ byref q ]( ) as Res
	return Fail( q )
end function
dim o as Res = f( )
print "init msg="; o.msg
var g = function[ byref q ]( ) as Plain
	return FailPlain( q )
end function
dim p as Plain = g( )
print "plain init msg="; p.msg
dim w as Plain = WithWork( function[ byref q ]( ) as Plain
	return FailPlain( q )
end function )
print "generic msg="; w.msg
