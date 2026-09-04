'' abi-descriptor-parity.bas -- Gate 1, in its strongest available form.
''
'' fbc PUBLISHES its own descriptor declarations in src/inc/fbc-int/*.bi, whose
'' header says outright "declarations must follow ./src/rtlib/fb_string.h". So
'' the parity check does not need a runner, a golden file, or a comparison
'' script: it is a #assert between two declarations in one translation unit.
''
'' That matters more than convenience. A test that must RUN can only check the
'' host target, and win64 is the target where every platform distinction
'' collapses. This one is checked by the compiler on win64, win32 AND
'' linux-x86_64, single- and multi-threaded, on every build/test.sh.
''
'' If any assertion here fires, tiko-rt's descriptors disagree with the ones fbc
'' hardcodes when it lays out a stack frame, and every string or array variable
'' in every compiled program is the wrong size.

#include once "inc/descriptors.bi"
#include once "fbc-int/string.bi"
#include once "fbc-int/array.bi"

'' -------------------------------------------------------------- FBSTRING

#assert sizeof( FBSTRING ) = sizeof( FBC.FBSTRING )
#assert offsetof( FBSTRING, data ) = offsetof( FBC.FBSTRING, data )
#assert offsetof( FBSTRING, len  ) = offsetof( FBC.FBSTRING, len  )
#assert offsetof( FBSTRING, size ) = offsetof( FBC.FBSTRING, size )

'' ------------------------------------------------------------- FBUSTRING
''
'' The one where a wrong answer is a factor of two rather than an offset:
'' len and size count CODE UNITS, and FB_UCHAR is USHORT on every target --
'' never wchar_t, which is 2 bytes on Windows and 4 on Linux.

#assert sizeof( FBUSTRING ) = sizeof( FBC.FBUSTRING )
#assert offsetof( FBUSTRING, data ) = offsetof( FBC.FBUSTRING, data )
#assert offsetof( FBUSTRING, len  ) = offsetof( FBC.FBUSTRING, len  )
#assert offsetof( FBUSTRING, size ) = offsetof( FBC.FBUSTRING, size )
#assert sizeof( FB_UCHAR ) = sizeof( FBC.FB_UCHAR )

'' --------------------------------------------------------------- FBARRAY

#assert sizeof( FBARRAYDIM ) = sizeof( FBC.FBARRAYDIM )
#assert offsetof( FBARRAYDIM, elements ) = offsetof( FBC.FBARRAYDIM, elements )
#assert offsetof( FBARRAYDIM, lbound_  ) = offsetof( FBC.FBARRAYDIM, lbound )
#assert offsetof( FBARRAYDIM, ubound_  ) = offsetof( FBC.FBARRAYDIM, ubound )

#assert sizeof( FBARRAY ) = sizeof( FBC.FBARRAY )
#assert offsetof( FBARRAY, index_ptr   ) = offsetof( FBC.FBARRAY, index_ptr )
#assert offsetof( FBARRAY, base_ptr    ) = offsetof( FBC.FBARRAY, base_ptr )
#assert offsetof( FBARRAY, size        ) = offsetof( FBC.FBARRAY, size )
#assert offsetof( FBARRAY, element_len ) = offsetof( FBC.FBARRAY, element_len )
#assert offsetof( FBARRAY, dimensions  ) = offsetof( FBC.FBARRAY, dimensions )
#assert offsetof( FBARRAY, flags       ) = offsetof( FBC.FBARRAY, flags )
'' offsetof over an array member needs an index -- a bare name is error 73.
#assert offsetof( FBARRAY, dimTb(0)    ) = offsetof( FBC.FBARRAY, dimTb(0) )

'' ---------------------------------------------------------------- constants

#assert FB_MAXDIMENSIONS = FBC.FB_MAXDIMENSIONS
#assert FBARRAY_FLAGS_DIMENSIONS = FBC.FBARRAY_FLAGS_DIMENSIONS
#assert FBARRAY_FLAGS_FIXED_DIM  = FBC.FBARRAY_FLAGS_FIXED_DIM
#assert FBARRAY_FLAGS_FIXED_LEN  = FBC.FBARRAY_FLAGS_FIXED_LEN
