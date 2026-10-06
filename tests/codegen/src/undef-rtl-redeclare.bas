#undef allocate
#undef deallocate
extern "C"
	declare function allocate cdecl alias "malloc" ( byval size as const uinteger ) as any ptr
	declare sub deallocate cdecl alias "free" ( byval p as const any ptr )
end extern
dim as integer ptr p = allocate( 16 )
p[1] = 42
print p[1]
deallocate( p )
