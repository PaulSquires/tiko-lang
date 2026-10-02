'' T66: LINE INPUT and INPUT from a text file into a ustring read characters, not bytes
'' taken as UTF-16. fbc-modern prints the same.
dim as long f = freefile
open "tests/codegen/src/ustr-input.txt" for input as #f
dim as ustring u, v, w
line input #f, u
input #f, v, w
close #f
print "[" & u & "] [" & v & "] [" & w & "]"; len( u ); len( w )
