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
** MACH-O has its own branch below: no priorities across objects, so this object also
** runs the program's numbered structors.
*/

#if defined( TKORT_MSVC )

/* msvcinit.c */

#elif defined( __APPLE__ )

/* MACH-O HAS NO PRIORITIES ACROSS OBJECTS.  ld64 runs every object's constructors in
** link order and ignores the number (measured on the Mac, docs/tiko-macos FACTS "M2 on
** the Mac"), so priority 100 above every module constructor would mean nothing here.
** What orders this one is its PLACE: LinkExe names fbrt0.o first, so its constructor runs
** before any other object's.
**
** AND THAT IS WHERE THE PROGRAM'S NUMBERED STRUCTORS RUN.  tiko does not put a numbered
** constructor or destructor ('constructor 101', the root's 65534 module init and drain)
** in LLVM's lists on Mach-O: it writes a { number, function } record into
** __DATA,__tko_ctors or __tko_dtors (src/codegen/llvmstructors.tiko).  ld64 gathers every
** object's records into one section and names its bounds section$start / section$end --
** zero-length, not missing, when no object has one.  They run here, in
** linux-x86_64's order whatever the link order:
**
**   start   fb_hRtInit; the numbered constructors, ascending, ties in record (link) order;
**           then, after this returns, every object's unnumbered constructors
**   exit    every unnumbered destructor; the numbered ones, descending, ties reversed;
**           fb_hRtExit
**
** THE EXIT HANDLER IS REGISTERED FIRST OF ALL, before fb_hRtInit: atexit is last in,
** first out, and the unnumbered destructors are __cxa_atexit'ed when their objects'
** constructors run, after this one -- so it runs after all of them, and after any
** handler the runtime registers while it runs, as the gnu .fini_array entry does. */

/* atexit, declared by hand: with no #include the runtime cross-builds for macOS on
** Windows, where the macOS SDK's headers are not (and may not be) present. */
int atexit( void ( *fn )( void ) );

struct tko_rec { long long prio; void ( *fn )( void ); };

extern const struct tko_rec tko_ctors_start __asm( "section$start$__DATA$__tko_ctors" );
extern const struct tko_rec tko_ctors_end   __asm( "section$end$__DATA$__tko_ctors" );
extern const struct tko_rec tko_dtors_start __asm( "section$start$__DATA$__tko_dtors" );
extern const struct tko_rec tko_dtors_end   __asm( "section$end$__DATA$__tko_dtors" );

void fb_hRtInit( void );
void fb_hRtExit( void );

/* Every record of [b, e) by number: ascending with ties in record order, or descending
** with ties reversed.  No allocation: one pass per distinct number, and there are few. */
static void fb_hRunRecs( const struct tko_rec *b, const struct tko_rec *e, int down )
{
	long long last = 0;
	int started = 0;
	for( ;; ) {
		long long next = 0;
		int found = 0;
		for( const struct tko_rec *r = b; r < e; r++ ) {
			int beyond = !started || ( down ? r->prio < last : r->prio > last );
			if( beyond && ( !found || ( down ? r->prio > next : r->prio < next ) ) ) {
				next = r->prio;
				found = 1;
			}
		}
		if( !found ) return;
		if( down ) {
			for( const struct tko_rec *r = e; r-- > b; )
				if( r->prio == next ) r->fn( );
		} else {
			for( const struct tko_rec *r = b; r < e; r++ )
				if( r->prio == next ) r->fn( );
		}
		last = next;
		started = 1;
	}
}

static void fb_hDoExit( void )
{
	fb_hRunRecs( &tko_dtors_start, &tko_dtors_end, 1 );
	fb_hRtExit( );
}

__attribute__(( constructor( 100 ) ))
static void fb_hDoInit( void )
{
	atexit( fb_hDoExit );
	fb_hRtInit( );
	fb_hRunRecs( &tko_ctors_start, &tko_ctors_end, 0 );
}

/* THE ENTRY POINT OF EVERY MACH-O EXECUTABLE, which LinkExe names with -e.  dyld calls it
** as it would call main -- after every initialiser, this object's above included -- and
** what it does is decided at LINK time by which tko_darwin_start the program got:
**
**   this one, WEAK     main( ) on this thread, exactly as without an entry of our own
**   libtkogfx's        AppKit keeps this thread -- it must: an NSWindow made anywhere else
**                      is an uncaught exception, measured -- and main( ) runs on a thread
**                      of its own (docs/graphics RFC-0012, model B, spike F5)
**
** A weak DEFINITION, not a weak reference: an archive member is loaded only to resolve an
** UNDEFINED symbol, so this never pulls libtkogfx in; but a program that uses graphics has
** already loaded its member for fb_Gfx*, and that member's strong definition replaces this
** one.  Not here in a dylib: -e is an executable's. */
int main( int argc, char **argv, char **envp );

__attribute__(( weak ))
int tko_darwin_start( int argc, char **argv, char **envp )
{
	return main( argc, argv, envp );
}

int tko_darwin_entry( int argc, char **argv, char **envp, char **apple )
{
	(void)apple;
	return tko_darwin_start( argc, argv, envp );
}

#else

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
