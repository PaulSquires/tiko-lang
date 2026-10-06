'' fbc moves only half a ustring's UTF-16 bytes through GET/PUT -- tiko refuses both plainly.
dim as ustring u = "ab"
open "x.tmp" for binary as #1
put #1, 1, u
get #1, 1, u
close #1
