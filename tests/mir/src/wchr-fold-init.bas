'' AN ALL-CONSTANT 'wchr' IS A LITERAL, and fbc folds it to one. Measured, both halves
'' from a single probe:
''
''   dim as wstring * 20 a : a = wchr( 65, 66, 67, 68 )
''     fb_WstrAssign( (uint16*)A$0, 20ll, (uint16*)L"ABCD" )
''   dim as long n = 70 : b = wchr( n )
''     uint16* vr$4 = fb_WstrChr( 1, (int64)N$0 );  ...  fb_WstrDelete( TMP$3$0 )
''
'' Emitting fb_WstrChr for the constant form is a wide temporary the caller owns and
'' nothing here deletes -- a leak per execution where fbc has a static global.
''
'' ...and A FIXED-LENGTH NARROW DESTINATION TAKES ITS OWN ELEMENT COUNT where a
'' var-length one takes -1:
''
''   dim s1 as zstring * 10 = wchr( 65 )
''     fb_WstrAssignToA_Init( (void*)S1$0, 10ll, (uint16*)L"A", 0ll )
''
'' Refusing anything but the var-length kind left 'zstring * N' to the narrow path,
'' which had no narrow source to find and declined.
dim as wstring * 20 a
a = wchr( 65, 66, 67, 68 )
dim as long n = 70
dim as wstring * 20 b
b = wchr( n )
dim s1 as zstring * 10 = wchr( 65 )
dim s2 as zstring * 10 = wstr( "B" )
print a, b, s1, s2
