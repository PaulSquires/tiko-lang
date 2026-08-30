'' ERASE OVER A FIXED ARRAY IS NOT ALWAYS A CLEAR. An FB fixed-length 'string * N' is
'' SPACE-PADDED and carries no terminator, so erasing one to NULs leaves N characters
'' that neither print nor compare as the blanks fbc leaves. Measured, one erase per
'' element kind:
''
''     string * 4    fb_ArrayFill( desc, 32 )
''     zstring * 4   fb_ArrayClear( desc )
''     wstring * 4   fb_ArrayClear( desc )
''
'' -- so it is the FB flavour alone, and 32 is the pad character. All three cleared
'' before, which string/string-fixed-array.bas asserts against directly: 'erase s1'
'' then CU_ASSERT( s1(0)[0] = 32 ).
dim as string * 4 fb_( 0 to 1 )
dim as zstring * 4 z( 0 to 1 )
dim as wstring * 4 w( 0 to 1 )
dim as long n( 0 to 1 )
dim as string v( 0 to 1 )

fb_(0) = "AB"
erase fb_
erase z
erase w
erase n
erase v
