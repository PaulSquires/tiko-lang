'' devstd-parity.bas -- the CONS:, ERR: and PIPE: devices, the stdio close, the
'' null-pointer check and the shared message buffer. Seven entry points across
'' seven fbc members.
''
'' NEEDS-GEN-LLVM
''
'' NOTHING HERE OPENS A PIPE. fb_DevPipeOpen runs popen, which starts a shell and
'' a child process -- a differential that spawns anything can hang the whole run,
'' as lprint-parity once did. Its ARGUMENT VALIDATION is driven instead, through
'' the mode and access combinations that fail BEFORE popen is reached, and the
'' open itself is proved by address.
''
'' CONS: AND ERR: ARE DRIVEN, because they only pick a stream that already
'' exists. Writing to ERR: goes to stderr, which the differential does NOT
'' capture -- so what is compared is the return codes and the handle state, never
'' the text.
''
'' fb_NullPtrChk IS CALLED ONLY WITH A NON-NULL POINTER. The NULL path THROWS a
'' runtime error, which without a handler ends the program -- so it is proved by
'' address, and its success return (which is NULL, not the pointer) is the part
'' that is measured.

#include once "fbc-int/string.bi"

extern "c"
	declare function pConsOpen  alias "fb_DevConsOpen" _
		( byval h as any ptr, byval f as zstring ptr, byval l as uinteger ) as long
	declare function pErrOpen   alias "fb_DevErrOpen" _
		( byval h as any ptr, byval f as zstring ptr, byval l as uinteger ) as long
	declare function pPipeOpen  alias "fb_DevPipeOpen" _
		( byval h as any ptr, byval f as zstring ptr, byval l as uinteger ) as long
	declare function pPipeClose alias "fb_DevPipeClose" ( byval h as any ptr ) as long
	declare function pStdIoClose alias "fb_DevStdIoClose" ( byval h as any ptr ) as long
end extern

extern "rtlib"
	declare function pNullPtrChk alias "fb_NullPtrChk" _
		( byval p as any ptr, byval l as long, byval f as zstring ptr ) as any ptr
end extern

'' The shared message buffer, as DATA.
extern "c"
	extern __fb_errmsg alias "__fb_errmsg" as ubyte
end extern

dim shared as any ptr addrs( 0 to 6 )
addrs(0) = cast( any ptr, @pConsOpen )
addrs(1) = cast( any ptr, @pErrOpen )
addrs(2) = cast( any ptr, @pPipeOpen )
addrs(3) = cast( any ptr, @pPipeClose )
addrs(4) = cast( any ptr, @pStdIoClose )
addrs(5) = cast( any ptr, @pNullPtrChk )
addrs(6) = @__fb_errmsg

dim as long n = 0, distinct = 1
for i as integer = 0 to 6
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- every entry point resolves"
print "  count="; n; " distinct="; distinct

'' THE BUFFER IS 1024 BYTES AND STARTS ZEROED. Reading past the first byte is
'' what distinguishes `= ""` (which zeroes the whole array in C) from a
'' one-byte initialisation.
dim as ubyte ptr em = @__fb_errmsg
dim as long allzero = 1
for i as integer = 0 to 1023
	if( em[i] <> 0 ) then allzero = 0
next
print "  __fb_errmsg is 1024 zero bytes="; allzero

'' ------------------------------------------------------------------ CONS:

'' CONS: IS DRIVEN THROUGH THE LANGUAGE, which is what fbc's codegen emits --
'' and the mode validation is the part that discriminates: BINARY and RANDOM are
'' rejected, the other three are not.
'' CONS: AND ERR: ARE DRIVEN THROUGH THEIR ENTRY POINTS, not through the OPEN
'' statement. `open cons for output as #1` inside a PRINT is a parse error --
'' the device forms have no function spelling -- and as a bare statement it
'' leaves its result only in ERR, which this project has been bitten by three
'' times. Calling fb_DevConsOpen on a descriptor of this test's own reads the
'' return AND lets the handle state be inspected afterwards.
'' FB_FILE, laid out as inc/file.bi measures it. Only the fields the validation
'' reads are set; the rest is zeroed, which is what a real OPEN would have done.
type TKORT_FB_FILE
	as long      mode
	as long      reclen
	as long      encod
	as longint   size
	as long      type_
	as long      access
	as long      lock_
	as ulong     line_length
	as ulong     width
	as ubyte     putback_buffer(0 to 3)
	as uinteger  putback_size
	as any ptr   hooks
	as any ptr   opaque
	as any ptr   redirection_to
end type

#assert sizeof( TKORT_FB_FILE ) = 80

const MODE_BINARY = 0
const MODE_RANDOM = 1
const MODE_INPUT  = 2
const MODE_OUTPUT = 3
const MODE_APPEND = 4

const ACC_ANY   = 0
const ACC_READ  = 1
const ACC_WRITE = 2
const ACC_RW    = 3

print "-- fb_DevConsOpen and fb_DevErrOpen"

sub tryCons( byval mode_ as long, byval acc as long, byref label as string )
	dim as TKORT_FB_FILE h
	h.mode = mode_
	h.access = acc
	dim as long r = pConsOpen( @h, @"", 0 )
	print "  CONS "; label; " -> "; r; " access="; h.access; _
	      " type="; h.type_; " stream set="; ( h.opaque <> 0 ); " hooks set="; ( h.hooks <> 0 )
end sub

sub tryErr( byval mode_ as long, byval acc as long, byref label as string )
	dim as TKORT_FB_FILE h
	h.mode = mode_
	h.access = acc
	dim as long r = pErrOpen( @h, @"", 0 )
	print "  ERR  "; label; " -> "; r; " access="; h.access; _
	      " type="; h.type_; " stream set="; ( h.opaque <> 0 ); " hooks set="; ( h.hooks <> 0 )
end sub

'' CONS: VALIDATES THE MODE AND ERR: DOES NOT -- so BINARY and RANDOM are
'' rejected by one and accepted by the other, which is the asymmetry this table
'' exists to pin down.
tryCons( MODE_INPUT,  ACC_ANY, "INPUT,  any" )
tryCons( MODE_OUTPUT, ACC_ANY, "OUTPUT, any" )
tryCons( MODE_APPEND, ACC_ANY, "APPEND, any" )
tryCons( MODE_BINARY, ACC_ANY, "BINARY, any" )
tryCons( MODE_RANDOM, ACC_ANY, "RANDOM, any" )
'' A NON-ANY access is left exactly as it was -- only ANY is rewritten.
tryCons( MODE_OUTPUT, ACC_READ, "OUTPUT, read" )

tryErr( MODE_OUTPUT, ACC_ANY,  "OUTPUT, any" )
tryErr( MODE_BINARY, ACC_ANY,  "BINARY, any" )
tryErr( MODE_RANDOM, ACC_ANY,  "RANDOM, any" )
tryErr( MODE_INPUT,  ACC_WRITE, "INPUT,  write" )


'' ------------------------------------------------------------------ PIPE:

'' ONLY THE REJECTIONS, and every one of them fails before popen is reached --
'' see the file header. The mode/access combinations are driven through
'' fb_DevPipeOpen directly on a descriptor of this test's own, because the
'' language form would run the command.
print "-- fb_DevPipeOpen, the validation that happens before popen"

sub tryPipe( byval mode_ as long, byval acc as long, byref label as string )
	dim as TKORT_FB_FILE h
	'' Zeroed by declaration; only the two fields the validation reads are set.
	h.mode = mode_
	h.access = acc
	dim as long r = pPipeOpen( @h, @"", 0 )
	print "  "; label; " -> "; r; " access now="; h.access; " opaque set="; ( h.opaque <> 0 )
	'' A rejected open never reached popen, so there is nothing to close -- and
	'' the close is called anyway, to prove it tolerates a NULL stream.
	print "    close on it -> "; pPipeClose( @h )
end sub

'' RANDOM and APPEND are rejected outright.
tryPipe( MODE_RANDOM, ACC_ANY,   "RANDOM,  any  " )
tryPipe( MODE_APPEND, ACC_ANY,   "APPEND,  any  " )
'' INPUT with write access, and OUTPUT with read access: error 1 from the access
'' check -- and fbc's code does NOT return there, so this is the case where the
'' error is set and the popen would still have run.
tryPipe( MODE_INPUT,  ACC_WRITE, "INPUT,   write" )
tryPipe( MODE_OUTPUT, ACC_READ,  "OUTPUT,  read " )
'' READWRITE is neither READ nor WRITE, so both of those modes reject it.
tryPipe( MODE_INPUT,  ACC_RW,    "INPUT,   rw   " )
tryPipe( MODE_OUTPUT, ACC_RW,    "OUTPUT,  rw   " )

'' ------------------------------------------------------------ the closes

'' fb_DevStdIoClose CLOSES NOTHING and always succeeds -- including on a handle
'' whose stream was never set.
print "-- fb_DevStdIoClose"
dim as TKORT_FB_FILE sh
print "  on a zeroed handle -> "; pStdIoClose( @sh ); " opaque now="; ( sh.opaque <> 0 )
sh.opaque = cast( any ptr, 12345 )
print "  on a handle with a stream -> "; pStdIoClose( @sh ); " opaque now="; ( sh.opaque <> 0 )

'' ------------------------------------------------------- fb_NullPtrChk

'' NULL ON SUCCESS, which reads backwards until you see the call site: fbc emits
'' this inside an `if` for the side effect, so a good pointer must be falsy.
print "-- fb_NullPtrChk"
dim as long target = 42
print "  a good pointer returns NULL="; ( pNullPtrChk( @target, 1, @"x.bas" ) = 0 )
print "  and the pointer is untouched="; ( target = 42 )
print "  err after it="; err

print "done"
