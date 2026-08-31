'' dylib.bas -- DYLIBLOAD/DYLIBSYMBOL/DYLIBFREE and the runtime's own internal
'' loader. Seven symbols over two fbc members, split by platform.
''
'' WINDOWS SEARCHES FOR A DECORATED NAME AND POSIX DOES NOT. A win32 stdcall
'' export is named `Foo@N`, where N is the argument byte count, and a caller who
'' wrote DYLIBSYMBOL( h, "Foo" ) has no way to know N. So the Windows side
'' retries `Foo@0`, `Foo@4`, ... up to `Foo@252` -- but ONLY when the plain name
'' failed AND the caller did not write an '@' themselves, because a caller who
'' did means it. This is why the same source finds a symbol on Windows that a
'' naive port would not.
''
'' POSIX SEARCHES FOR A DECORATED FILENAME instead, which is the mirror image:
'' "foo", "libfoo", "libfoo.so", "./foo", "./libfoo", "./libfoo.so", in that
'' order. A caller writes the library's NAME and the platform's convention is
'' applied for them.
''
'' THE TERMINAL IS RESET AROUND dlopen AND dlclose ON POSIX, and that is not
'' cosmetic. If the shared library is ITSELF a FreeBASIC program it carries its
'' own rtlib, which captures the terminal state when it initialises. Handing it a
'' terminal this rtlib has already modified would make the second rtlib restore
'' the wrong state on exit -- and it exits AFTER this one, because the user may
'' never call DYLIBFREE. Resetting first lets each capture and restore its own.
''
'' fb_DylibSymbolByOrd IS NULL ON POSIX and real on Windows. ELF has no ordinal
'' export table; there is nothing to look up, and returning NULL is the honest
'' answer rather than a fabricated failure code.
''
'' fb_hDynLoad IS THE RUNTIME'S OWN LOADER, not the user's: it takes a
'' NULL-terminated name table and fills a parallel pointer table, and fails
'' ALL-OR-NOTHING -- one missing entry point unloads the library and returns
'' NULL, because a half-bound table would fault at the first call instead of at
'' the load. On POSIX it looks in the EXECUTABLE ITSELF first, so a statically
'' linked copy wins over a shared one.

#include once "inc/descriptors.bi"
#include once "inc/iolock.bi"
#include once "crt/string.bi"

extern "c"   '' NON-FBCALL: the internal temp-descriptor helper.
	declare sub tkrt_StrDelTemp alias "fb_hStrDelTemp" ( byval s as FBSTRING ptr )
end extern

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

'' ---------------------------------------------------------- Windows backend

const TKORT_PROCNAME_MAX = 1024

extern "c"   '' NON-FBCALL: kernel32 imports, not rtlib entry points.
	declare function w_LoadLibraryA stdcall alias "LoadLibraryA" ( byval n as zstring ptr ) as any ptr
	declare function w_FreeLibrary stdcall alias "FreeLibrary" ( byval h as any ptr ) as long
	declare function w_GetProcAddress stdcall alias "GetProcAddress" ( byval h as any ptr, byval n as zstring ptr ) as any ptr
	declare function w_GetModuleHandleA stdcall alias "GetModuleHandleA" ( byval n as zstring ptr ) as any ptr
	declare function c_snprintf alias "snprintf" ( byval buf as zstring ptr, byval n as uinteger, byval fmt as zstring ptr, ... ) as long
	declare function c_strchr alias "strchr" ( byval s as zstring ptr, byval c as long ) as zstring ptr
end extern

extern "rtlib"

function tkort_DylibLoad alias "fb_DylibLoad" ( byval library as FBSTRING ptr ) as any ptr
	dim as any ptr res = 0

	if( library <> 0 ) then
		if( library->data <> 0 ) then res = w_LoadLibraryA( library->data )
	end if

	'' del if temp
	tkrt_StrDelTemp( library )

	return res
end function

function tkort_DylibSymbol alias "fb_DylibSymbol" _
	( byval library as any ptr, byval symbol as FBSTRING ptr ) as any ptr

	dim as any ptr proc_ = 0
	dim as zstring * TKORT_PROCNAME_MAX procname = any
	dim as long i = any

	'' A NULL library means THIS executable, which is what makes
	'' DYLIBSYMBOL( 0, "name" ) resolve a symbol the program itself exports.
	if( library = 0 ) then library = w_GetModuleHandleA( 0 )

	if( symbol <> 0 ) then
		if( symbol->data <> 0 ) then
			proc_ = w_GetProcAddress( library, symbol->data )

			'' The stdcall retry -- see the file header. Skipped when the caller
			'' wrote an '@' of their own.
			if( (proc_ = 0) andalso (c_strchr( symbol->data, 64 ) = 0) ) then
				for i = 0 to 252 step 4
					c_snprintf( @procname, TKORT_PROCNAME_MAX - 1, @"%s@%d", symbol->data, i )
					proc_ = w_GetProcAddress( library, @procname )
					if( proc_ <> 0 ) then exit for
				next
			end if
		end if
	end if

	'' del if temp
	tkrt_StrDelTemp( symbol )

	return proc_
end function

function tkort_DylibSymbolByOrd alias "fb_DylibSymbolByOrd" _
	( byval library as any ptr, byval symbol as short ) as any ptr

	if( library = 0 ) then library = w_GetModuleHandleA( 0 )

	'' MAKEINTRESOURCE: an ordinal is passed to GetProcAddress as a POINTER
	'' whose high bits are zero, not as a string. Casting the number straight to
	'' a pointer is the macro, and the zero-extension is what tells the loader
	'' it is an ordinal.
	return w_GetProcAddress( library, cptr( zstring ptr, cast( uinteger, cast( ushort, symbol ) ) ) )
end function

sub tkort_DylibFree alias "fb_DylibFree" ( byval library as any ptr )
	w_FreeLibrary( library )
end sub

end extern

'' -------------------------------------------------- the runtime's own loader

extern "c"   '' NON-FBCALL: internal, declared plain in fb_private_hdynload.h.

function tkort_hDynLoad alias "fb_hDynLoad" _
	( byval libname as zstring ptr, byval funcname as zstring ptr ptr, _
	  byval funcptr as any ptr ptr ) as any ptr

	dim as any ptr hlib = any
	dim as integer i = any

	hlib = w_LoadLibraryA( libname )
	if( hlib = 0 ) then return 0

	'' ALL OR NOTHING -- see the file header.
	i = 0
	while( funcname[i] <> 0 )
		funcptr[i] = w_GetProcAddress( hlib, funcname[i] )
		if( funcptr[i] = 0 ) then
			w_FreeLibrary( hlib )
			return 0
		end if
		i += 1
	wend

	return hlib
end function

function tkort_hDynLoadAlso alias "fb_hDynLoadAlso" _
	( byval hlib as any ptr, byval funcname as zstring ptr ptr, _
	  byval funcptr as any ptr ptr, byval count as integer ) as long

	dim as integer i = any

	for i = 0 to count - 1
		funcptr[i] = w_GetProcAddress( hlib, funcname[i] )
		if( funcptr[i] = 0 ) then return -1
	next

	return 0
end function

sub tkort_hDynUnload alias "fb_hDynUnload" ( byval hlib as any ptr ptr )
	if( *hlib <> 0 ) then
		w_FreeLibrary( *hlib )
		*hlib = 0
	end if
end sub

end extern

#else

'' ------------------------------------------------------------ POSIX backend

const TKORT_MAX_PATH = 1024
const RTLD_LAZY_ = 1

extern "c"   '' NON-FBCALL: libdl and libc, plus two of fbc's own helpers.
	declare function u_dlopen alias "dlopen" ( byval n as zstring ptr, byval flags as long ) as any ptr
	declare function u_dlsym alias "dlsym" ( byval h as any ptr, byval n as zstring ptr ) as any ptr
	declare function u_dlclose alias "dlclose" ( byval h as any ptr ) as long
	declare function c_snprintf alias "snprintf" ( byval buf as zstring ptr, byval n as uinteger, byval fmt as zstring ptr, ... ) as long

	'' fbc's own, and they stay fbc's: the console teardown lives in hinit.o and
	'' the path rewriter in file_hconvpath.o.
	declare sub tkrt_hInitConsole alias "fb_hInitConsole" ( )
	declare sub tkrt_hExitConsole alias "fb_hExitConsole" ( )
	declare sub tkrt_hConvertPath alias "fb_hConvertPath" ( byval p as zstring ptr )
end extern

'' The filename conventions, tried in order. A trailing 0 terminates the table.
dim shared as zstring ptr tkort_libfmt( 0 to 6 ) = { _
	@"%s", @"hlib%s", @"hlib%s.so", @"./%s", @"./hlib%s", @"./hlib%s.so", 0 }

extern "rtlib"

function tkort_DylibLoad alias "fb_DylibLoad" ( byval library as FBSTRING ptr ) as any ptr
	dim as any ptr res = 0
	dim as zstring * TKORT_MAX_PATH libname = any
	dim as integer i = any

	'' Reset the terminal around the load -- see the file header.
	TKORT_IOLOCK()
	tkrt_hExitConsole( )
	TKORT_IOUNLOCK()

	if( library <> 0 ) then
		if( library->data <> 0 ) then
			i = 0
			while( tkort_libfmt(i) <> 0 )
				c_snprintf( @libname, TKORT_MAX_PATH - 1, tkort_libfmt(i), library->data )
				tkrt_hConvertPath( @libname )
				res = u_dlopen( @libname, RTLD_LAZY_ )
				if( res <> 0 ) then exit while
				i += 1
			wend
		end if
	end if

	'' del if temp
	tkrt_StrDelTemp( library )

	TKORT_IOLOCK()
	tkrt_hInitConsole( )
	TKORT_IOUNLOCK()

	return res
end function

function tkort_DylibSymbol alias "fb_DylibSymbol" _
	( byval library as any ptr, byval symbol as FBSTRING ptr ) as any ptr

	dim as any ptr proc_ = 0

	'' dlopen( NULL ) is the running executable, which is how
	'' DYLIBSYMBOL( 0, "name" ) reaches a symbol the program itself exports.
	if( library = 0 ) then library = u_dlopen( 0, RTLD_LAZY_ )

	if( symbol <> 0 ) then
		if( symbol->data <> 0 ) then proc_ = u_dlsym( library, symbol->data )
	end if

	'' del if temp
	tkrt_StrDelTemp( symbol )

	return proc_
end function

'' ELF has no ordinal export table, so there is nothing to look up. NULL is the
'' honest answer rather than a fabricated failure code.
function tkort_DylibSymbolByOrd alias "fb_DylibSymbolByOrd" _
	( byval library as any ptr, byval symbol as short ) as any ptr
	scope : dim as any ptr unused_l = library : dim as short unused_s = symbol : end scope
	return 0
end function

sub tkort_DylibFree alias "fb_DylibFree" ( byval library as any ptr )
	'' The same terminal dance as the load: if it is an FB library it restores
	'' the terminal state as it shuts down.
	TKORT_IOLOCK()
	tkrt_hExitConsole( )
	TKORT_IOUNLOCK()

	u_dlclose( library )

	TKORT_IOLOCK()
	tkrt_hInitConsole( )
	TKORT_IOUNLOCK()
end sub

end extern

'' -------------------------------------------------- the runtime's own loader

extern "c"   '' NON-FBCALL: internal, declared plain in fb_private_hdynload.h.

function tkort_hDynLoad alias "fb_hDynLoad" _
	( byval libname as zstring ptr, byval funcname as zstring ptr ptr, _
	  byval funcptr as any ptr ptr ) as any ptr

	dim as any ptr hlib = any
	dim as integer i = any

	'' THE EXECUTABLE ITSELF IS TRIED FIRST, so a statically linked copy of the
	'' library wins over a shared one. The FIRST name in the table is the probe:
	'' if the running image does not have it, the image handle is dropped and the
	'' named library is opened instead.
	hlib = u_dlopen( 0, RTLD_LAZY_ )
	if( hlib = 0 ) then return 0

	if( u_dlsym( hlib, funcname[0] ) = 0 ) then
		u_dlclose( hlib )
		hlib = u_dlopen( libname, RTLD_LAZY_ )
		if( hlib = 0 ) then return 0
	end if

	'' ALL OR NOTHING -- see the file header.
	i = 0
	while( funcname[i] <> 0 )
		funcptr[i] = u_dlsym( hlib, funcname[i] )
		if( funcptr[i] = 0 ) then
			u_dlclose( hlib )
			return 0
		end if
		i += 1
	wend

	return hlib
end function

function tkort_hDynLoadAlso alias "fb_hDynLoadAlso" _
	( byval hlib as any ptr, byval funcname as zstring ptr ptr, _
	  byval funcptr as any ptr ptr, byval count as integer ) as long

	dim as integer i = any

	for i = 0 to count - 1
		funcptr[i] = u_dlsym( hlib, funcname[i] )
		if( funcptr[i] = 0 ) then return -1
	next

	return 0
end function

sub tkort_hDynUnload alias "fb_hDynUnload" ( byval hlib as any ptr ptr )
	if( *hlib <> 0 ) then
		u_dlclose( *hlib )
		*hlib = 0
	end if
end sub

end extern

#endif
