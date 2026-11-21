/* fbrtapp.c -- an Android app's entry, for 'tiko -app' (docs/tiko-android A4).
**
** WHAT IT IS.  A loose object, like fbrt0.o: nothing in a program refers to it, so the driver
** names it on the link of an app (toolchain.tiko LinkExe) and only there. build/build.sh
** installs it as lib/android-<arch>/fbrtapp.o, position-independent.
**
** WHAT IT DOES.  SDL's Java side (SDLActivity, via TikoActivity) loads libmain.so and calls
** SDL_main on a thread of its own once the Activity is up. Under -app the compiler names the main
** module's function tko_AppMain rather than main, and this SDL_main runs it, after three things:
**
**   1. stdout and stderr go to logcat. An app's are /dev/null; PRINT would vanish. A pipe, a
**      reader thread, and one __android_log_write per line, tag "tiko".
**   2. The return path. SDL's rule, measured (FACTS A4): returning from SDL_main makes SDL finish
**      the Activity, while exit( ) on this thread kills the app with SIGABRT in Android's render
**      thread. fb_End -- the program's end and END -- calls the handler registered here
**      (tkort_SetAppEnd, init/rtinit.tiko), which longjmps back to SDL_main. On any other
**      thread it returns, and fb_End exits as it always did.
**   3. The end a program has anywhere else, here. The process outlives SDL_main, and when it goes
**      ART skips native clean-up ("VM exiting ... cleanup skipped"): measured, a module destructor
**      never ran. So SDL_main does what exit( ) would, in exit's order for an SDL program that
**      quits SDL and ends: SDL_Quit (also after an END that skipped the program's own, which left
**      SDL complaining of a live EGL context), then libmain.so's .fini_array backwards -- module
**      destructors, then fbrt0's fb_hRtExit, which closes the files -- and stdio flushed.
**
** NO HEADERS: like fbrt0.c this is compiled without a sysroot, so the few Bionic and liblog
** entries are declared by hand. They are stable NDK ABI. */

#if defined( __ANDROID__ )

typedef long tko_pthread_t;     /* Bionic's pthread_t is a long */

int pipe( int fds[2] );
int dup2( int oldfd, int newfd );
long read( int fd, void *buf, unsigned long n );
int pthread_create( tko_pthread_t *t, const void *attr, void *( *fn )( void * ), void *arg );
int pthread_detach( tko_pthread_t t );
tko_pthread_t pthread_self( void );
int setvbuf( void *stream, char *buf, int mode, unsigned long size );
int fflush( void *stream );
extern void *stdout;
int __android_log_write( int prio, const char *tag, const char *text );
/* Bionic's jmp_buf is long[] of 64 bytes or more (x86_64 88, arm64 256: pkg/sys/posix); this is
** larger than either, and aligned for both. */
typedef long long tko_jmp_buf[64] __attribute__(( aligned( 16 ) ));
int setjmp( long long *env ) __attribute__(( returns_twice ));
void longjmp( long long *env, int val ) __attribute__(( noreturn ));

void SDL_Quit( void ) __attribute__(( weak ));
/* lld names a shared library's own .fini_array bounds too; hidden, so they are this one's. */
extern void ( *__fini_array_start[] )( void ) __attribute__(( visibility( "hidden" ), weak ));
extern void ( *__fini_array_end[] )( void ) __attribute__(( visibility( "hidden" ), weak ));
void tkort_SetAppEnd( void ( *fn )( int errlevel ) );
void tkort_SetAppExeDot( void );
int chdir( const char *path );
const char *SDL_GetAndroidInternalStoragePath( void ) __attribute__(( weak ));
int tko_AppMain( int argc, char **argv );

#define TKO_LOG_INFO 4
#define TKO_IOLBF 1     /* Bionic's _IOLBF */

static int tko_app_pipe[2];
static tko_jmp_buf tko_app_jb;
static volatile int tko_app_code;
static tko_pthread_t tko_app_thread;
static volatile int tko_app_running;

/* One logcat line per output line; a line longer than the buffer goes out in pieces. */
static void *tko_app_logger( void *arg )
{
	static char buf[1024];
	unsigned long n = 0;
	(void)arg;
	for( ;; ) {
		long r = read( tko_app_pipe[0], buf + n, sizeof( buf ) - 1 - n );
		if( r <= 0 ) break;
		n += (unsigned long)r;
		unsigned long start = 0;
		for( unsigned long i = 0; i < n; i++ ) {
			if( buf[i] == '\n' ) {
				buf[i] = 0;
				if( i > start && buf[i - 1] == '\r' ) buf[i - 1] = 0;
				__android_log_write( TKO_LOG_INFO, "tiko", buf + start );
				start = i + 1;
			}
		}
		if( start == 0 && n == sizeof( buf ) - 1 ) {
			buf[n] = 0;
			__android_log_write( TKO_LOG_INFO, "tiko", buf );
			n = 0;
		} else {
			for( unsigned long i = start; i < n; i++ ) buf[i - start] = buf[i];
			n -= start;
		}
	}
	return 0;
}

static void tko_app_logcat( void )
{
	tko_pthread_t t;
	if( pipe( tko_app_pipe ) != 0 ) return;
	setvbuf( stdout, 0, TKO_IOLBF, 0 );
	dup2( tko_app_pipe[1], 1 );
	dup2( tko_app_pipe[1], 2 );
	if( pthread_create( &t, 0, tko_app_logger, 0 ) == 0 ) pthread_detach( t );
}

/* libmain.so's destructors, last first, as exit( ) and dlclose run them; Bionic's linker skips
** the 0 and -1 entries, and so does this. */
static void tko_app_fini( void )
{
	if( !__fini_array_start || !__fini_array_end ) return;
	for( void ( **f )( void ) = __fini_array_end; f > __fini_array_start; ) {
		--f;
		if( *f && *f != ( void ( * )( void ) )-1 ) ( *f )( );
	}
}

/* fb_End's hook: back to SDL_main, on SDL_main's own thread only. */
static void tko_app_end( int errlevel )
{
	if( !tko_app_running || pthread_self( ) != tko_app_thread ) return;
	tko_app_code = errlevel;
	longjmp( tko_app_jb, 1 );
}

__attribute__(( visibility( "default" ) ))
int SDL_main( int argc, char **argv )
{
	static int logging;
	if( !logging ) { logging = 1; tko_app_logcat( ); }
	tko_app_thread = pthread_self( );
	tkort_SetAppEnd( tko_app_end );
	tkort_SetAppExeDot( );          /* EXEPATH is "." -- the assets (sys/hostinfo.tiko) */
	/* THE WORKING DIRECTORY IS THE APP'S OWN STORAGE. An app starts in "/", which it cannot write:
	** a program that saves "notes.txt", or copies a photo in, failed there (measured, A5). Its
	** internal storage (/data/user/0/<id>/files) is private, kept across runs and writable. */
	if( SDL_GetAndroidInternalStoragePath ) {
		const char *home = SDL_GetAndroidInternalStoragePath( );
		if( home ) chdir( home );
	}
	tko_app_code = 0;
	tko_app_running = 1;
	if( setjmp( tko_app_jb ) == 0 ) tko_app_code = tko_AppMain( argc, argv );
	tko_app_running = 0;
	if( SDL_Quit ) SDL_Quit( );
	tko_app_fini( );
	fflush( 0 );
	return tko_app_code;
}

#else

/* Not an Android target: nothing (build/build.sh builds this for android-* only). */
typedef int tko_fbrtapp_empty;

#endif
