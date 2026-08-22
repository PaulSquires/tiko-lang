'' OPEN, every clause spelling. The mode, access and lock words are SMALL INTEGERS to
'' the runtime rather than separate entry points, and the codes were measured from
'' fbc's own C output -- BINARY 0, RANDOM 1, INPUT 2, OUTPUT 3, APPEND 4, with a
'' missing FOR meaning RANDOM rather than zero.
dim as string f = "x.txt"
open f for input as #1
open f for output as #2
open f for append as #3
open f for binary as #4
open f for random as #5
open f as #6
open f for input access read as #7
'' 'access' must stop at 'lock': consuming keywords to 'as' read this as one four-word
'' access list and gave access 3, lock 0, where fbc gives access 2, lock 3.
open f for output access write lock read write as #8
open f for random as #9 len = 128
'' SHARED compiles to lock 0 -- indistinguishable from writing no LOCK at all.
open f for output shared as #10
open "lit.txt" for binary as #11
'' In EXPRESSION position the whole thing is the error code.
dim as long e = open( f for input as #12 )
close
