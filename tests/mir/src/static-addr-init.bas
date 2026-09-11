'' AN ADDRESS IN AN INTEGER SLOT IS A ptrtoint.
''
'' 'static f as uinteger = cptr( uinteger, @g )' is a RELOCATION written into an INTEGER
'' global, and a bare symbol there is LLVM's "global variable reference must have
'' pointer type" -- it will not narrow a relocation implicitly:
''
''     @"...$f" = global i64 @"...1SEv"
''
'' A static initialiser has to be a constant EXPRESSION, and ptrtoint is one.
dim shared as integer g = 7
function f3( ) as uinteger
	static f as uinteger = cptr( uinteger, @g )
	return f
end function
dim as uinteger want = cptr( uinteger, @g )
print f3( ) = want
print f3( )
print want

'' ...and a PROCEDURE's address, which is the shape dim/static-const-init writes.
sub subp( )
end sub

function f4( ) as uinteger
	static f as uinteger = cptr( uinteger, @subp )
	return f
end function

dim as uinteger want2 = cptr( uinteger, @subp )
print f4( ) = want2

'' the pointer-typed spelling beside it, which always worked
function f5( ) as any ptr
	static f as any ptr = @subp
	return f
end function

print f5( ) = @subp
