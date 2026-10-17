'' A TEMPORARY STRING KEY FOR 'operator []( byref k as string )' is copied before the call,
'' as an ordinary call's byref string argument is. tiko passed the concatenation's own
'' temporary, so the operator's 'names( n ) = k' took its buffer and the statement then
'' freed it: updates were lost, a 'str( )' key stored as empty, and 't[ k ] = t[ k ] + 1'
'' freed the buffer twice. Expected output is fbc-modern 1.20's.
type Tbl
    as string names( 0 to 7 )
    as long vals( 0 to 7 )
    as long n
    declare operator [] ( byref k as string ) byref as long
end type

operator Tbl.[] ( byref k as string ) byref as long
    for i as long = 0 to this.n - 1
        if this.names( i ) = k then return this.vals( i )
    next
    this.names( this.n ) = k
    this.vals( this.n ) = 0
    this.n += 1
    return this.vals( this.n - 1 )
end operator

dim as Tbl t
dim as string v = "a"
t[v] += 1
t[v] += 1
t["b" & ""] += 1
t["b" & ""] += 1
t[str( 7 )] += 1
t[str( 7 )] += 1
t["c"] += 1
t["c"] += 1
for i as long = 1 to 4
    t["d" & ( i mod 2 )] = t["d" & ( i mod 2 )] + 1
next
dim as long q = t["e" & ""]
q = t["e" & ""]
print t.n
for i as long = 0 to t.n - 1
    print "[" & t.names( i ) & "]"; t.vals( i )
next
