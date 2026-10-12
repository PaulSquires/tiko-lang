/* fbrt0.c -- the runtime's startup and shutdown hooks, for the gnu targets.
**
** WHAT THIS REPLACES.  fbc's own fbrt0.o, which the compiler names on every gnu
** link (toolchain.tiko LinkExe, first match across the library paths) and which
** was the last file of fbc's that a win64 or linux-x86_64 program still took
** from lib/<target>-fb/.  It is the ONLY caller of fb_hRtInit, and so of fb_hInit:
** nothing refers to it by name, which is why it is a loose object the driver
** names and NOT an archive member -- a member is pulled in only to satisfy an
** undefined symbol, and this one satisfies none.  build/build.sh installs it as
** lib/<target>/fbrt0.o beside libfb.a, and fbrt0pic.o for a Linux shared library,
** so the library search finds it before any copy in lib/<target>-fb/.
**
** WHAT IT IS, measured with llvm-nm and llvm-objdump on both of fbc's packaged
** copies (win64 and linux-x86_64), not read from fbc's source: two local
** functions, one calling fb_hRtInit and one fb_hRtExit, registered through
** .ctors.65435 and .dtors.65435 -- constructor and destructor PRIORITY 100.
**
** WHY 100.  FreeBASIC's lowest priority a program can write is 101 (PROBE-4,
** README), so 100 runs before every module constructor and its destructor after
** every module destructor.  clang lowers the attribute to the same ordering the
** program's own constructors use -- .ctors.<65535-n> on MinGW, .init_array.<n>
** on ELF -- so the relationship holds by construction rather than by matching
** fbc's section names.
**
** MSVC HAS ITS OWN, msvcinit.c, pulled in by /INCLUDE; this file is empty there.
*/

#ifndef TKORT_MSVC

void fb_hRtInit( void );
void fb_hRtExit( void );

__attribute__(( constructor( 100 ) ))
static void fb_hDoInit( void )
{
	fb_hRtInit( );
}

__attribute__(( destructor( 100 ) ))
static void fb_hDoExit( void )
{
	fb_hRtExit( );
}

#endif
