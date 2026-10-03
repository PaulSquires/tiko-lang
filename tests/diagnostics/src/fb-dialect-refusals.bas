'' See ../fb-dialect-refusals.test.
'$include: 'nothing.bi'
sub Hello( )
end sub
dim as long k = 1
dim as long a, b
type P
    as long x, y
end type
dim pp as P = ( 1, 2 )
let k = 5
call Hello( )
lprint "x"
option explicit
on k gosub done
defint a-z
deflng b-c
10 print "ten"
20 print "twenty"
let ( a, b ) = pp
Hello( )
k = 2 : 0 = 1
done:
