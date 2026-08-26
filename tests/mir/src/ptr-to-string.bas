'' 'str( p )' AND 'wstr( p )' OVER A POINTER, which were refused and left the call
'' untyped -- and an untyped argument takes the enclosing statement with it.
''
'' A POINTER RENDERS AS ITS ADDRESS, unsigned. Measured, and the same for every pointer
'' type -- a 'wstring ptr' and an 'any ptr' alike:
''
''   str( p )    fb_ULongintToStr( (uint64)P$0 )
''   wstr( p )   fb_ULongintToWstr( (uint64)P$0 )
''
'' The dispatch reads the entry point off the BUILTIN, and a pointer is not one, so it
'' fell out of the select with nothing. This is the second half of what
'' overload/strings_ptr.bas was declining -- 'proc( wsp, wstr( wsp ) )' is a wide
'' pointer rendered as a number and passed as a wstring, which reads oddly and is
'' exactly what the test asserts.
declare function pw( byval b as wstring ptr ) as long

dim as wstring ptr wsp
dim as any ptr ap
dim as long ptr lp
dim as long r

print str( wsp )
print str( ap )
print str( lp )
print wstr( wsp )

r = pw( wstr( wsp ) )
print r

function pw( byval b as wstring ptr ) as long
    return 1
end function
