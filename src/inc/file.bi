#ifndef __TKORT_FILE_BI__
#define __TKORT_FILE_BI__

'' file.bi -- FB_FILE, its hook table, and the file-handle lookup.
''
'' NO ENTRY POINTS DEPEND ON THIS YET. It lands on its own because getting it
'' wrong is not a compile error and not a crash: FB_FILE_TO_HANDLE is pointer
'' arithmetic into fbc's own file table, so a wrong offset yields a PLAUSIBLE
'' FB_FILE pointer that reads and writes the middle of a neighbouring entry.
'' Every File*, Dev*, Con* and Print* entry point -- 262 of the 810 still
'' outstanding -- goes through it, so it is worth proving before anything is
'' built on top.
''
'' ================================================== HOW THE LAYOUT WAS FIXED
''
'' Not by reading the struct and counting -- that was tried and it was wrong.
''
'' A C probe compiled against fbc's OWN HEADERS gave the two 64-bit targets:
''
''                        win64   linux-x86_64   win32
''     sizeof FB_FILE        80             80      64
''     hooks                 56             56      52
''     opaque                64             64      56
''     fileTB (in ctx)      296            296     152
''     FB_RESERVED_FILES      2              2       2
''
'' NO 32-BIT MinGW HEADERS ARE AVAILABLE HERE, so win32 could not be probed that
'' way. Its fileTB offset was first DERIVED by counting members under ILP32
'' rules, which produced 148 -- off by four. Nothing crashed: `width` read back
'' 0 instead of 40, `mode` read 0 on an open handle, and `hooks` was null. A
'' plausible pointer into the wrong place, exactly as the header above warns.
''
'' The real number came from ASKING THE RUNTIME: set a distinctive width on an
'' open handle, scan __fb_ctx for the entry whose width field holds it, and work
'' back to the table base. Run on win64 FIRST AS A CONTROL, where it returned
'' 296 -- matching the C probe exactly -- and only then on win32, where it
'' returned 152.
''
'' All three targets are then verified behaviourally by
'' tests/abi/filebind-parity.bas, which drives each field from a public
'' statement and reads it back through this binding. Measured stride: 80 on the
'' 64-bit targets, 64 on win32, both matching sizeof( FB_FILE ).

#include once "inc/descriptors.bi"

'' Forward: the hook signatures name FB_FILE and FB_FILE names the hook table.
type FB_FILE as FB_FILE_

'' The hook table. Fourteen function pointers, and the ORDER is the contract --
'' an entry point that calls the wrong slot calls a real function with the wrong
'' signature, which is a crash at best.
''
'' TYPED, not `any ptr`. The dispatchers in src/io/file.bas call these directly,
'' and a wrong signature here is a wrong calling sequence at every call site
'' rather than a compile error at one.
type FnFileEof         as function cdecl ( byval h as FB_FILE ptr ) as long
type FnFileClose       as function cdecl ( byval h as FB_FILE ptr ) as long
type FnFileSeek        as function cdecl ( byval h as FB_FILE ptr, byval offset as longint, byval whence as long ) as long
type FnFileTell        as function cdecl ( byval h as FB_FILE ptr, byval pOffset as longint ptr ) as long
type FnFileRead        as function cdecl ( byval h as FB_FILE ptr, byval value as any ptr, byval pLen as uinteger ptr ) as long
type FnFileReadWstr    as function cdecl ( byval h as FB_FILE ptr, byval value as wstring ptr, byval pLen as uinteger ptr ) as long
type FnFileWrite       as function cdecl ( byval h as FB_FILE ptr, byval value as any ptr, byval length as uinteger ) as long
type FnFileWriteWstr   as function cdecl ( byval h as FB_FILE ptr, byval value as wstring ptr, byval length as uinteger ) as long
type FnFileLock        as function cdecl ( byval h as FB_FILE ptr, byval pos as longint, byval size as longint ) as long
type FnFileUnlock      as function cdecl ( byval h as FB_FILE ptr, byval pos as longint, byval size as longint ) as long
type FnFileReadLine    as function cdecl ( byval h as FB_FILE ptr, byval dst as FBSTRING ptr ) as long
type FnFileReadLineWstr as function cdecl ( byval h as FB_FILE ptr, byval dst as wstring ptr, byval dst_chars as integer ) as long
type FnFileSetWidth    as function cdecl ( byval h as FB_FILE ptr, byval new_width as long ) as long
type FnFileFlush       as function cdecl ( byval h as FB_FILE ptr ) as long

type FB_FILE_HOOKS
	as FnFileEof           pfnEof
	as FnFileClose         pfnClose
	as FnFileSeek          pfnSeek
	as FnFileTell          pfnTell
	as FnFileRead          pfnRead
	as FnFileReadWstr      pfnReadWstr
	as FnFileWrite         pfnWrite
	as FnFileWriteWstr     pfnWriteWstr
	as FnFileLock          pfnLock
	as FnFileUnlock        pfnUnlock
	as FnFileReadLine      pfnReadLine
	as FnFileReadLineWstr  pfnReadLineWstr
	as FnFileSetWidth      pfnSetWidth
	as FnFileFlush         pfnFlush
end type

'' NOT byte-packed: this mirrors a struct the C compiler laid out, and packing it
'' is the mistake that put __fb_ctx.null_desc four bytes early in inc/ctx.bi and
'' returned a pointer into the middle of a descriptor.
type FB_FILE_
	as long      mode
	'' fbc calls this `len`; it is the RECORD length for RANDOM files, and it is
	'' a C `int` -- genuinely 32-bit, not a pointer-width length. Named reclen
	'' both because `len` is a FreeBASIC keyword and because the index-width lint
	'' is right to object to a `long` called length: this one is a struct field
	'' mirroring an int, not an index.
	as long      reclen
	as long      encod            '' FB_FILE_ENCOD, a C enum -> int
	as longint   size             '' fb_off_t, 64-bit on all three targets
	as long      type_            '' `type` is a keyword too
	as long      access
	as long      lock_            '' and `lock`
	as ulong     line_length
	as ulong     width
	as ubyte     putback_buffer(0 to 3)
	as uinteger  putback_size     '' size_t: pointer-width
	as FB_FILE_HOOKS ptr hooks
	as any ptr   opaque
	as FB_FILE ptr redirection_to
end type

'' Checked on the two targets a C probe could be built for. win32 is covered by
'' the behavioural test instead -- see the header.
#if defined( __FB_64BIT__ )
	#assert sizeof( FB_FILE_HOOKS ) = 112
	#assert sizeof( FB_FILE )       = 80
	#assert offsetof( FB_FILE, size )           = 16
	#assert offsetof( FB_FILE, width )          = 40
	#assert offsetof( FB_FILE, putback_size )   = 48
	#assert offsetof( FB_FILE, hooks )          = 56
	#assert offsetof( FB_FILE, opaque )         = 64
	#assert offsetof( FB_FILE, redirection_to ) = 72
	const TKORT_FILETB_OFFSET = 296
#else
	#assert sizeof( FB_FILE_HOOKS ) = 56
	#assert sizeof( FB_FILE )       = 64
	#assert offsetof( FB_FILE, size )           = 16
	#assert offsetof( FB_FILE, width )          = 40
	#assert offsetof( FB_FILE, hooks )          = 52
	#assert offsetof( FB_FILE, opaque )         = 56
	const TKORT_FILETB_OFFSET = 152
#endif

const FB_RESERVED_FILES = 2

'' __fb_ctx as raw bytes, so the file table can be reached by its measured offset
'' without binding the 20,872-byte context struct in full -- most of which is
'' fields no entry point here will ever touch, each an opportunity to get a
'' layout wrong for no benefit.
extern "c"   '' NON-FBCALL: __fb_ctx is DATA, not a procedure.
	extern __fb_ctx_bytes alias "__fb_ctx" as ubyte
end extern

#define TKORT_FILETB() cptr( FB_FILE ptr, @__fb_ctx_bytes + TKORT_FILETB_OFFSET )


'' THE TWO SPECIAL FILE NUMBERS ARE TABLE ENTRIES, NOT SENTINELS -- and getting
'' that wrong produced a PRINT that emitted absolutely nothing while fbc's own
'' 2,715-file suite still passed.
''
''     0   -> __fb_ctx.fileTB       the screen
''     -1  -> __fb_ctx.fileTB + 1   the PRINTER, not an error stream
''
'' The first version of this header guessed 0 for the screen and invented an
'' "error" handle for -1. Passing NULL to fb_hFilePrintBufferEx is not a crash
'' and not an error return: it writes nowhere, silently, so every PRINT in every
'' program produced empty output and nothing said so.
''
'' FB_RESERVED_FILES = 2 is exactly these two, which is why an ordinary file
'' number lands at fileTB + (n - 1 + 2).
''
'' AND THE INDEX IS RANGE-CHECKED. An out-of-range file number yields NULL --
'' which the writer then ignores -- rather than an entry past the end of the
'' table. Omitting the check turns a bad file number into a write into whatever
'' follows fileTB in the context struct.
const FB_MAX_FILES = FB_RESERVED_FILES + 255

#define TKORT_FILE_INDEX_VALID( n ) _
	( ((n) >= 1) andalso ((n) <= (FB_MAX_FILES - FB_RESERVED_FILES)) )

#define TKORT_FILE_TO_HANDLE( n ) _
	iif( (n) = 0, TKORT_FILETB(), _
	     iif( (n) = -1, TKORT_FILETB() + 1, _
	          iif( TKORT_FILE_INDEX_VALID( n ), _
	               TKORT_FILETB() + ((n) - 1 + FB_RESERVED_FILES), _
	               cptr( FB_FILE ptr, 0 ) ) ) )

'' The open modes, and the test every dispatcher starts with.
''
'' FB_HANDLE_USED IS A HOOKS CHECK, NOT A NULL CHECK: a handle in the table that
'' was never opened has a null hooks pointer, and calling through it is the
'' crash the test exists to prevent.
const FB_FILE_MODE_BINARY = 0
const FB_FILE_MODE_RANDOM = 1
const FB_FILE_MODE_INPUT  = 2
const FB_FILE_MODE_OUTPUT = 3
const FB_FILE_MODE_APPEND = 4

#define TKORT_HANDLE_USED( h ) ( ((h) <> 0) andalso ((h)->hooks <> 0) )

'' FB_FILE_ENCOD, in fb_file.h's order. ASCII is 0 and is also
'' FB_FILE_ENCOD_DEFAULT, so a zeroed handle is an ASCII handle -- the encoding
'' field needs no explicit initialisation anywhere, and adding a member before
'' ASCII would silently change what an uninitialised handle means.
const FB_FILE_ENCOD_ASCII = 0
const FB_FILE_ENCOD_UTF8  = 1
const FB_FILE_ENCOD_UTF16 = 2
const FB_FILE_ENCOD_UTF32 = 3

#endif '' __TKORT_FILE_BI__
