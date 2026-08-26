'' DIR, which was not implemented at all -- not in the intrinsic type table, so every
'' assignment from one had nothing to store, and not lowered either.
'' file/dir-overloads.bas is fifteen lines of nothing else.
''
'' Measured, every row:
''
''   dir( )                   fb_DirNext( (int32*)0 )
''   dir( "*" )               fb_Dir( desc, 33, (int32*)0 )
''   dir( "*", fbNormal )     fb_Dir( desc, 33, (int32*)0 )
''   dir( "*", , l )          fb_Dir( desc, 33, &L )
''   dir( "*", , ll )         fb_Dir64( desc, 33, &LL )
''   dir( l )                 fb_DirNext( &L )
''   dir( ll )                fb_DirNext64( &LL )
''
'' THREE THINGS THAT ARE NOT GUESSABLE. The default attribute is 33 -- fbNormal, which
'' is fbReadOnly or fbArchive -- and not 0. The OUT PARAMETER'S WIDTH picks the entry
'' point: four bytes takes fb_Dir / fb_DirNext and eight takes fb_Dir64 /
'' fb_DirNext64, which are separate symbols in libfb and not a cast of the same one --
'' so 'integer', being eight bytes on win64, takes the 64 form there. And 'dir( l )'
'' with a NUMBER where the pattern goes is not a pattern at all: it is the
'' continuation form with an out parameter, so the FIRST ARGUMENT'S TYPE decides which
'' of the two families the call belongs to.
''
'' The out argument is passed BY ADDRESS when it is an lvalue and BY VALUE when it is
'' already a pointer: 'dir( "*", , l )' and 'dir( "*", , @l )' both reach the runtime
'' as '&L$0'.
'' dir.bi is three #defines and nothing else; they are written out here rather than
'' included, so this test needs no include path.
#define fbReadOnly &h01
#define fbArchive  &h20
#define fbNormal   (fbReadOnly or fbArchive)

dim as long l
dim as longint ll
dim as string s

s = dir( "*" )
s = dir( "*", fbNormal )
s = dir( "*", , l )
s = dir( "*", , ll )
s = dir( "*", , @l )
s = dir( "*", , @ll )
s = dir( "*", fbNormal, l )
s = dir( "*", fbNormal, ll )

s = dir( )
s = dir( l )
s = dir( ll )
s = dir( @l )
s = dir( @ll )

print dir( "*" )
