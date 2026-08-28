'' 'spawn f( a )' -- RFC-0003's goroutine statement, desugared in the parser.
''
'' fbc builds a GENERIC frame extending FB.SpawnWork, a generic 'make', a virtual
'' INVOKE and FB.SpawnTrampoline as the callback -- measured, for a UDT argument:
''
''   __fbspawnmake( U* A0 ) { F = calloc( 32, 1 ); frame::ctor( F );
''                            U::operator=( &F->A0, A0 );
''                            fb_Spawn( &FB::SpawnTrampoline, F ); }
''   frame::INVOKE( THIS )  { U::ctor( &TMP, &THIS->A0 ); WORKER( &TMP );
''                            U::dtor( &TMP ); }
''
'' The virtual call is there because fbc's frame is a generic instantiation whose
'' address cannot be taken -- its own header says so. tiko-lang names the frame itself
'' and so passes a PLAIN thunk to fb_Spawn: same allocate, same copy in, same copy out,
'' same destroy-and-free, no vtable.
'' fb/scheduler.bi is DECLARED HERE rather than included, so the test needs no
'' toolchain headers on the machine running it. This is the header's own declaration,
'' narrowed to the one entry point the desugaring names.
namespace FB
#ifdef __FB_WIN32__
	#ifdef __FB_64BIT__
		extern "C"
	#else
		extern "Windows"
	#endif
#else
	extern "C"
#endif
#ifdef __FB_WIN32__
declare sub Spawn alias "fb_Spawn" _
	( byval work as sub stdcall( byval ctx as any ptr ), byval ctx as any ptr = 0 )
#else
declare sub Spawn alias "fb_Spawn" _
	( byval work as sub cdecl( byval ctx as any ptr ), byval ctx as any ptr = 0 )
#endif
end extern
end namespace
type U
	as string s
end type
sub worker( byval n as long )
	print n
end sub
sub uworker( byval uw as U )
	print uw.s
end sub
dim as U uu
uu.s = "hi"
spawn worker( 7 )
spawn uworker( uu )
sleep 200
