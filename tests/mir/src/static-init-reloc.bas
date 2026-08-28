'' A STATIC POINTER INITIALISED FROM A PROCEDURE'S ADDRESS is a RELOCATION, in all
'' three spellings. Measured -- fbc emits 'static void* F$1 = (void*)&S' for each.
sub s( )
end sub

sub t( )
	static f as any ptr = procptr( s )
	static g as any ptr = cptr( any ptr, @s )
	static h as any ptr = @s
	print f, g, h
end sub
t( )

'' ...and a NAMED CONSTANT in a shared initialiser folds. 'true' is the shape that
'' matters: fbc emits 'static boolean B$ = (boolean)1' and this used to emit no
'' initialiser at all, so the global read FALSE.
dim shared bt as boolean = true
dim shared bf as boolean = false
print bt, bf
