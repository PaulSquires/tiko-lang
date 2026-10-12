'' THE WIDE MEMORY FAMILY LINKS ON windows-x86_64. wmemmove, wmemcpy, wmemset, wmemcmp and
'' wmemchr are inline in the UCRT headers and exported by nothing, so crt/wchar.bi's
'' declarations reached the link undefined -- AfxNova's DWSTRING calls wmemmove, and
'' PsCalendar stopped there. tiko-rt's msvccrt.c defines them. fbc-modern prints:
''
''    zzllo-1108
#include once "crt/wchar.bi"
dim as wstring * 16 a = "hello", b
wmemmove( @b, @a, 6 )
wmemset( @b, asc( "z" ), 2 )
print b; wmemcmp( @a, @b, 5 ) > 0; *wmemchr( @a, asc( "l" ), 5 )
