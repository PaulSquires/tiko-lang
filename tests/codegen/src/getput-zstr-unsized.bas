'' GET / PUT of '*pz', an UNSIZED zstring: fbc passes length 0, which the runtime reads as strlen.
dim as zstring * 16 z = "abcdef"
dim as zstring ptr pz = @z
dim as string fn = "getput-zstr-unsized.tmp"
open fn for binary as #1
put #1, 1, *pz
close #1
z = "xyz"
open fn for binary as #1
get #1, 1, *pz
close #1
kill fn
print "["; z; "] "; len( z )
