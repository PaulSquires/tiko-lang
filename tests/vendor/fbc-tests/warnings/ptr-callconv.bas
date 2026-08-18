extern "windows"
	sub fWindows( byval i as integer )
	end sub
end extern

extern "windows-ms"
	sub fWindowsMs( byval i as integer )
	end sub
end extern

sub fStdcall stdcall( byval i as integer )
end sub

sub fCdecl cdecl( byval i as integer )
end sub

sub fDefault( byval i as integer )
end sub

dim pStdcall as sub stdcall( byval as integer )
dim pCdecl as sub cdecl( byval as integer )
dim pDefault as sub( byval as integer )
dim p1 as sub stdcall( )
dim p2 as sub cdecl  ( )
dim p3 as sub pascal ( )

#print "pStdcall = @fWindows"
pStdcall = @fWindows
#print "pStdcall = @fWindowsMs"
pStdcall = @fWindowsMs
#print "pStdcall = @fStdcall"
pStdcall = @fStdcall
#print "pCdecl = @fCdecl"
pCdecl = @fCdecl
#print "pDefault = @fDefault"
pDefault = @fDefault

'' CDECL vs STDCALL DO NOT WARN ON 64-BIT.
''
'' Stock fbc warns here even on x86_64 -- where the conventions have no effect
'' -- so that a mismatch which WOULD be a bug on x86 is still reported. That
'' trade is off in fbc-modern, which has dropped 32-bit entirely: there is no
'' x86 target left for the warning to protect, and the cost of keeping it is
'' real. windows.h declares WNDPROC as WINAPI, WINAPI is defined away on win64,
'' so the imported typedef says CDECL while FreeBASIC's own default is STDCALL
'' -- and every Win32 callback written the way the documentation says to write
'' it warned against an imported header, with no spelling that silenced it.
''
'' See symbAreProcModesEqual( ).
#print "pCdecl = @fWindows"
pCdecl = @fWindows
#print "pCdecl = @fWindowsMs"
pCdecl = @fWindowsMs
#print "pCdecl = @fStdcall"
pCdecl = @fStdcall
#print "pStdcall = @fCdecl"
pStdcall = @fCdecl

#print "p1 = p2"
p1 = p2

'' PASCAL IS STILL INCOMPATIBLE, and must stay so. It is not a mangling or a
'' register difference: it reverses the argument order, on x86-64 as anywhere
'' else. Calling a PASCAL procedure through a CDECL pointer with (1, 2) returns
'' 21 rather than 12.
#print "p1 = p3"
p1 = p3

#print "p2 = p1"
p2 = p1
#print "p2 = p3"
p2 = p3

#print "p3 = p1"
p3 = p1
#print "p3 = p2"
p3 = p2
