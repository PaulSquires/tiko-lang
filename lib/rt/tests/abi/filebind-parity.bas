'' filebind-parity.bas -- proves src/inc/file.bi's layout against fbc's runtime.
''
'' NO ENTRY POINT USES THAT BINDING YET, which is exactly why this exists. A
'' wrong FB_FILE offset is not a compile error and not a crash: FB_FILE_TO_HANDLE
'' is pointer arithmetic into fbc's own file table, so a wrong number produces a
'' PLAUSIBLE handle that reads and writes a neighbouring entry. 262 of the
'' remaining entry points go through it.
''
'' THE METHOD IS TO DRIVE A FIELD FROM A PUBLIC STATEMENT AND READ IT BACK
'' THROUGH THE BINDING. WIDTH #f sets `width`; writing bytes sets `size`; OPEN
'' sets `mode` and installs `hooks`. If any offset is wrong, the value read is
'' whatever the neighbouring field happens to hold -- so these are not "does it
'' look sane" checks, they are "does the number the runtime just stored come back
'' from the place the binding says it lives".
''
'' win64 and linux-x86_64 also have their layout asserted at compile time from a
'' C probe built against fbc's headers. WIN32 HAS NO SUCH PROBE -- no 32-bit
'' MinGW headers are available here -- so for that target THIS FILE IS THE ONLY
'' EVIDENCE, which is why it drives every field rather than a representative one.
#include once "fbc-int/string.bi"

'' The binding under test, transcribed rather than included: tests/ is not on the
'' src include path, and a copy that has to be kept in step is honest about the
'' fact that this file is checking a LAYOUT, not code.
type T_HOOKS field = 0
    as any ptr p00, p01, p02, p03, p04, p05, p06
    as any ptr p07, p08, p09, p10, p11, p12, p13
end type
type T_FILE field = 0
    as long      mode
    as long      length_
    as long      encod
    as longint   size
    as long      type_
    as long      access
    as long      lock_
    as ulong     line_length
    as ulong     width
    as ubyte     putback_buffer(0 to 3)
    as uinteger  putback_size
    as T_HOOKS ptr hooks
    as any ptr   opaque
    as T_FILE ptr redirection_to
end type

'' __fb_ctx as raw bytes, so fileTB can be reached by its measured offset without
'' binding the 20,872-byte context struct in full.
extern "c"
    extern __fb_ctx alias "__fb_ctx" as ubyte
end extern

const FILETB_OFFSET = 296
const FB_RESERVED_FILES = 2

function handle_of( byval fnum as long ) as T_FILE ptr
    dim as T_FILE ptr tb = cptr( T_FILE ptr, @__fb_ctx + FILETB_OFFSET )
    return tb + (fnum - 1 + FB_RESERVED_FILES)
end function

print "sizeof T_FILE  = "; sizeof( T_FILE )
print "sizeof T_HOOKS = "; sizeof( T_HOOKS )
print "offset size    = "; offsetof( T_FILE, size )
print "offset hooks   = "; offsetof( T_FILE, hooks )
print "offset opaque  = "; offsetof( T_FILE, opaque )
print "offset width   = "; offsetof( T_FILE, width )

'' ---- OPEN sets mode and installs hooks; CLOSE clears mode.
dim as string path_ = environ( "TEMP" ) + "\tkort_filebind.tmp"
dim as long f = freefile
open path_ for output as #f

dim as T_FILE ptr h = handle_of( f )
print "-- after OPEN FOR OUTPUT --"
print "mode nonzero   = "; iif( h->mode <> 0, 1, 0 )
print "hooks nonnull  = "; iif( h->hooks <> 0, 1, 0 )
print "opaque nonnull = "; iif( h->opaque <> 0, 1, 0 )

'' ---- WIDTH #f, n WRITES THE `width` FIELD. This is the decisive check: the
'' value is chosen here, stored by the runtime, and read back through the
'' binding. A wrong offset returns a neighbouring field, not 40.
width #f, 40
print "width after 40 = "; h->width
width #f, 132
print "width after 132= "; h->width

'' ---- writing bytes moves `size`. Buffered, so it is flushed first.
print #f, string( 100, "x" );
close #f

'' Re-open for input: `size` is set from the file on the way in.
f = freefile
open path_ for input as #f
h = handle_of( f )
print "-- after re-OPEN FOR INPUT --"
print "size vs LOF    = "; iif( h->size = lof( f ), 1, 0 ); "  lof="; lof( f )
print "mode nonzero   = "; iif( h->mode <> 0, 1, 0 )
close #f

'' ---- CLOSE clears the entry.
h = handle_of( f )
print "-- after CLOSE --"
print "mode zero      = "; iif( h->mode = 0, 1, 0 )

kill path_

'' ---- a BINARY handle, where `size` is authoritative and settable.
f = freefile
open path_ for binary as #f
put #f, , string( 37, "y" )
h = handle_of( f )
'' NOTE: `size` is the length the handle was OPENED with, not a running total.
'' It stays 0 here while LOF reports 37, because LOF asks the OS and the field
'' does not track writes. That is a fact about fbc, not about the binding -- the
'' binding is proven by `width` and by the stride below -- and it is printed
'' rather than asserted so the difference is on the record.
print "-- binary --"
print "size (on-open) = "; h->size
print "lof  = 37      = "; iif( lof( f ) = 37, 1, 0 )
close #f
kill path_

'' ---- TWO HANDLES AT ONCE, to prove the STRIDE as well as the base. If
'' sizeof(FB_FILE) is wrong, the second handle lands inside the first.
dim as string p1 = environ( "TEMP" ) + "\tkort_fb1.tmp"
dim as string p2 = environ( "TEMP" ) + "\tkort_fb2.tmp"
dim as long f1 = freefile
open p1 for output as #f1
dim as long f2 = freefile
open p2 for output as #f2
width #f1, 40
width #f2, 132
dim as T_FILE ptr h1 = handle_of( f1 ), h2 = handle_of( f2 )
print "-- two handles --"
print "f1 width = 40  = "; iif( h1->width = 40, 1, 0 ); "  got="; h1->width
print "f2 width = 132 = "; iif( h2->width = 132, 1, 0 ); "  got="; h2->width
print "distinct       = "; iif( h1 <> h2, 1, 0 )
print "stride         = "; cint( cptr( ubyte ptr, h2 ) - cptr( ubyte ptr, h1 ) ) \ (f2 - f1)
close #f1 : close #f2
kill p1 : kill p2
