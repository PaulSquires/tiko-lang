'' iolock.bi -- the runtime's global I/O lock, or nothing at all.
''
'' ONE ARCHIVE'S SOURCE BUILDS BOTH libfb.a AND libfbmt.a, selected by
'' ENABLE_MT, exactly as fbc's C build does. In the single-threaded archive
'' these expand to NOTHING -- not to a no-op call -- so an unlocked build pays
'' zero for the lock and the two archives differ in generated code rather than
'' in behaviour at run time.
''
'' The macros are spelled with the trailing () so a mistyped `IOLOCK` without
'' them fails to compile in the MT build rather than silently expanding to a
'' bare identifier in the ST one.

#pragma once

#ifdef ENABLE_MT
	extern "rtlib"
		declare sub fb_Lock alias "fb_Lock" ( )
		declare sub fb_Unlock alias "fb_Unlock" ( )
	end extern
	#define TKORT_IOLOCK()   fb_Lock()
	#define TKORT_IOUNLOCK() fb_Unlock()
#else
	#define TKORT_IOLOCK()
	#define TKORT_IOUNLOCK()
#endif
