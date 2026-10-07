'' An fb_ name is predeclared only when it IS a runtime procedure. fbc-modern 1.20
'' (2026-10-07): error 42 on lines 5 and 6; lines 8 and 9 compile.
dim as string s = "a_b"
dim as long n
s = fb_StrRemove( s, "_" )
n = fb_NoSuchThing( 1 )

dim as any ptr p = procptr( fb_ArrayRedimEx )
print p <> 0
