'' '@wstr( "w1" )' AND 'print *pz' -- two shapes a parameter default is written in.
''
'' A WIDE STRING IS ALREADY A POINTER, so its address is that pointer and not the
'' address of a temporary holding one. Measured: fbc folds the whole thing to
'' '(uint16*)L"w1"', the literal's own storage. Asking LowerAddr for a CALL's address
'' instead gave nothing, and 'byval pw as const wstring ptr = @wstr( "w1" )' declined
'' with it -- which is how functions/paraminit writes every wide default.
''
'' AND A ZSTRING BORROWS A DESCRIPTOR the same way a 'string * N' does, from its own
'' entry point: 'print *pz' is 'fb_StrAllocTempDescZ( PZ )' and then fb_PrintString.
'' Only the fixed narrow flavour had a branch, so every print through a zstring pointer
'' declined.
dim as const wstring ptr pw = @wstr( "w1" )
print *pw

dim as const zstring ptr pz = @"z1"
print *pz

sub t1( byval p as const wstring ptr = @wstr( "d1" ) )
	print *p
end sub

sub t2( byval p as const zstring ptr = @"d2" )
	print *p
end sub

t1( )
t2( )
t1( @wstr( "given" ) )
