'' A string argument whose CALLEE WRITES IT, or whose shape needs a conversion: does the change come
'' back, and does the callee see the right text? (P-A sweep differences, run rather than compared.)
sub pru( byref x as ustring )
    print "  pru saw ["; x; "]"
    x = "U-new"
end sub
sub prs( byref x as string )
    print "  prs saw ["; x; "]"
    x = "S-new"
end sub
sub ppz( byval x as zstring ptr )
    print "  ppz saw ["; *x; "]"
end sub
dim as string s = "str"
dim as string * 8 f = "fix"
dim as zstring * 8 z = "zst"
dim as wstring * 8 w = wstr( "wst" )
dim as ustring * 8 uf = "ufx"
print "pru(s)" : pru( s ) : print "  s=["; s; "]"
print "pru(f)" : pru( f ) : print "  f=["; f; "]"
print "pru(z)" : pru( z ) : print "  z=["; z; "]"
print "pru(w)" : pru( w ) : print "  w=["; w; "]"
print "prs(uf)" : prs( uf ) : print "  uf=["; uf; "]"
f = "fix"
print "ppz(f)" : ppz( f )
dim as string fn = "strarg-copyback.tmp"
open fn for output as #1
print #1, "line one"
print #1, "word"
close #1
open fn for input as #1
line input #1, uf
print "line input uf=["; uf; "]"
input #1, uf
print "input uf=["; uf; "]"
close #1
kill fn
