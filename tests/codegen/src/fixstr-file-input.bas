open "fixstr-file-input.txt" for output as #1
print #1, "abcdefg"
print #1, "xy"
write #1, "q1", "q2", "q3"
close #1
dim as string * 4 f
dim as zstring * 4 z
dim as wstring * 4 w
open "fixstr-file-input.txt" for input as #1
line input #1, f
print "[" & f & "]"; len(f)
line input #1, z
print "[" & z & "]"
input #1, z, w, f
print "[" & z & "][" & w & "][" & f & "]"
close #1
open "fixstr-file-input.bin" for binary as #1
put #1, 1, "abcdefgh"
get #1, 1, z
print "[" & z & "]"; len(z)
get #1, 1, f
print "[" & f & "]"
close #1
dim as wstring * 8 w2 = "abcdef"
rset w2, "QQ"
print "[" & w2 & "]"
dim as string * 6 f2 = "abcdef"
rset f2, "QQ"
print "[" & f2 & "]"
kill "fixstr-file-input.txt" : kill "fixstr-file-input.bin"
dim as zstring * 6 z6 = "ab"
dim as string * 4 f4 = "xy"
open "fixstr-file-input2.bin" for binary as #1
put #1, 1, z6
put #1, , f4
print lof(1)
close #1
kill "fixstr-file-input2.bin"
