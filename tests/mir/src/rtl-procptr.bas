'' 'procptr( fb_Xxx )' OVER THE ADDRESSABLE RUNTIME.
''
'' warnings/rtl-prototypes.bas takes the address of 554 entry points and asserts each is
'' non-null. 84 of them named nothing in tiko-lang's table, so the expression had no
'' value at all and the assignment declined -- every one of that file's declines, from
'' ONE cause, and none of them a feature.
''
'' The sample below is one per awkward class rather than all 84:
''
''   fb_LPrintInt      the LPRINT family. The STATEMENT is dialect-gated -- 'lprint "x"'
''                     is fbc error 146, "Only valid in -lang deprecated or fblite or
''                     qb" -- but taking the ADDRESS of the entry point is not, so this
''                     is in scope where the statement is not.
''   fb_ErrorResume    CDECL on win32, alone among the fb_Error family, so its link name
''                     is '_fb_ErrorResume' with no '@N'.
''   fb_MemMove        declared under a DIFFERENT NAME: what fbc emits for it is plain
''                     'memmove'. Eleven others are like it -- memcpy, pow, rename,
''                     atexit, __main, libgcc's four division helpers, __fixunsdfdi, and
''                     fb_LeftSelf, whose runtime name is the shouted fb_LEFTSELF.
''   fb_FileGet        a SECOND entry point beside the one PUT/GET already uses: that
''                     one is fb_FileGetLarge on win64, and this is the 32-bit-position
''                     form, a different function with the same family name.
''   fb_ThreadCall     VARIADIC, and cdecl on win32 for that reason.
''   fb_ArrayBoundChkEx  emitted only under -exx, but NAMEABLE without it.
''
'' Every signature was measured from the C 'fbc -r -gen gcc' leaves behind, on both
'' targets, and 'z' is the letter wherever win64 declares int64 and win32 int32.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

dim chk as any ptr

chk = procptr( fb_LPrintInt )      : assert_( chk <> 0 )
chk = procptr( fb_LPrintString )   : assert_( chk <> 0 )
chk = procptr( fb_ErrorResume )    : assert_( chk <> 0 )
chk = procptr( fb_ErrorSetHandler ): assert_( chk <> 0 )
chk = procptr( fb_MemMove )        : assert_( chk <> 0 )
chk = procptr( fb_MemCopy )        : assert_( chk <> 0 )
chk = procptr( fb_LeftSelf )       : assert_( chk <> 0 )
chk = procptr( fb_FileGet )        : assert_( chk <> 0 )
chk = procptr( fb_FilePut )        : assert_( chk <> 0 )
chk = procptr( fb_ThreadCall )     : assert_( chk <> 0 )
chk = procptr( fb_ArrayBoundChkEx ): assert_( chk <> 0 )
chk = procptr( fb_IsTypeOf )       : assert_( chk <> 0 )
chk = procptr( fb_CVLONGINTFROMD ) : assert_( chk <> 0 )
chk = procptr( fb_hPutAdd )        : assert_( chk <> 0 )
chk = procptr( fb_MemCopyClear )   : assert_( chk <> 0 )
