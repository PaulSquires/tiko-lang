'' Narrow string items that lowering declined (P-A sweep, tka-probes/phase4/pa): WRITE and PRINT
'' USING of a 'string * N', 'zstring * N' and '*pz' item and of a concatenation; LSET / RSET of a
'' ustring and a 'ustring * N' from a literal and from a concatenation; PUT of a call's result and
'' of a concatenation. Each now goes through a temporary descriptor, as fbc's does.
dim as string * 8 f = "fixed"
dim as zstring * 8 z = "zstr"
dim as zstring ptr pz = @z
dim as string s = "ab"
write f, z, *pz, s & "x"
print using "[&] [&] [&]"; f; z; *pz
dim as ustring u = "abcdef"
dim as ustring * 6 uf = "uvwxyz"
lset u, "x"
print "["; u; "]"
rset uf, "y"
print "["; uf; "]"
lset uf, s & "!"
print "["; uf; "]"
function getres( ) as string
    return "result"
end function
dim as string fn = "t_strargs1.tmp"
open fn for binary as #1
put #1, 1, getres( )
put #1, , s & "-cat"
close #1
open fn for binary as #1
dim as string back = space( lof( 1 ) )
get #1, 1, back
close #1
kill fn
print "["; back; "]"
